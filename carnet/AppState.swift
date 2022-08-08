//
//  AppState.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 19.07.2022.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

enum MainAppState {

    case notAuth(AuthError? = nil)
    case authenticating
    case authenticated
    
    var authError: String? {
        switch self {
        case let .notAuth(error): return error?.localizedDescription
        default: return nil
        }
    }
}

@MainActor class AppState: ObservableObject {
    private let api = ApiClient()
    
    @Published var state: MainAppState = .notAuth()
    
    @Published var driver: Loadable<DriverInfo> = .notRequested
    
    @Published var alarmSystem: Loadable<AlarmSystem> = .notRequested
    
    @Published var replacements: Loadable<ReplacementParametersResponse> = .notRequested
    
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    
    @Published var markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), tint: .blue))]
    
    private var cancelables = Set<AnyCancellable>()
    
    private var isRefreshed: Bool = false
    
    func load() async {
//        let sema = DispatchSemaphore(value: 0)
//        api.RefreshPublisher()
//            .sink { completion in
//                switch completion {
//                case .failure(let error):
//                    print(error)
//                case .finished:
//                    print("finished")
//                }
//            } receiveValue: { isRefreshed in
//                defer { sema.signal() }
//                self.isRefreshed = isRefreshed
//
//            }
//            .store(in: &cancelables)
//        sema.wait()
        self.driver = .notRequested
        self.alarmSystem = .notRequested
        self.replacements = .notRequested
        if (!(await api.refreshToken())) {
            if !(await api.logout()) {
                print("can't logout")
            }
            self.state = .notAuth()
            return
        }
        
        self.saveTokenInKeychain()
        
        api.GetDriver()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.driver = Loadable.failed(error)
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { driver in
                self.driver = Loadable.loaded(driver)
            }
            .store(in: &cancelables)

        api.GetReplacements()
            //.delay(for: 5, scheduler: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.replacements = Loadable.failed(error)
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { replacements in
                self.replacements = Loadable.loaded(replacements)
            }
            .store(in: &cancelables)
            
       api.GetAlarmSystem()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alarmSystem = Loadable.failed(error)
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { alarmSystem in
                self.alarmSystem = Loadable.loaded(alarmSystem)
                let coord = CLLocationCoordinate2D(latitude: alarmSystem.last_gps.x, longitude: alarmSystem.last_gps.y)
                self.mapRegion.center = coord
                self.markers[0] = Marker(location: MapMarker(coordinate: coord, tint: .blue))
            }
            .store(in: &cancelables)
    }
    
    deinit {
        self.cancelables.removeAll()
    }
    
    func signIn(email: String, password: String) async throws {
        try await api.auth(email, password)
    }
    
    var token: RefreshTokenResponse? {
        get {
            api.currentToken
        }
    }
    
    func saveTokenInKeychain() {
        if self.token != nil {
            KeychainHelper.standard.save(self.token,
                                         service: Constants.TOKEN_SERVICE_NAME, account: Constants.ACCOUNT_NAME)
        }
    }
    
    func loadTokenFromKeychain() {
        let token = KeychainHelper.standard.read(service: Constants.TOKEN_SERVICE_NAME, account: Constants.ACCOUNT_NAME,
                                                 type: RefreshTokenResponse.self)
        api.currentToken = token
        if api.currentToken?.access_token != nil {
            self.state = .authenticated
        }
    }
    
    func logout() async {
        if !(await api.logout()) {
            print("can't logout")
        }
        KeychainHelper.standard.delete(service: Constants.TOKEN_SERVICE_NAME, account: Constants.ACCOUNT_NAME)
        self.state = .notAuth()
    }
}
