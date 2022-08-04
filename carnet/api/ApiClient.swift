//
//  apiClient.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 06.07.2022.
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case networkError(Error)
    
    /// Invalid request, e.g. invalid URL
    case invalidRequestError(String)

    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)

    case invalidResponse
      
    /// Server-side validation error
    case validationError(String)

    /// The server sent data in an unexpected format
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
            case .invalidRequestError(let message):
                return "Invalid request: \(message)"
            case .transportError(let error):
                return "Transport error: \(error)"
            case .invalidResponse:
                return "Invalid response"
            case .validationError(let reason):
                return "Validation Error: \(reason)"
            case .decodingError:
                return "The server returned data in an unexpected format. Try updating the app."
            case .networkError(let error):
                return "Network error: \(error)"
        }
    }
}

class ApiClient {
    private var currentToken: RefreshTokenResponse?
    // set rest api service base url
    let baseApi = ""
    
    func auth(_ email: String, _ password: String) async -> Bool {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        do {
            let token = try await Send("\(baseApi)/auth/login", method: "POST", parameters: parameters) as AuthToken?
            if token != nil {
                currentToken = RefreshTokenResponse(access_token: token?.access_token ?? "", refresh_token: token?.refresh_token ?? "")
                return true
            }
            return false
        }
        catch {
            return false
        }
    }
    
    func refreshToken() async -> Bool {
        let parameters: [String: Any] = [
            "refresh_token": currentToken?.refresh_token ?? ""
        ]
        
        do {
            
            let token = try await Send("\(baseApi)/auth/refresh", method: "POST", parameters: parameters) as RefreshTokenResponse?
            if token != nil {
                currentToken = token
                return true
            }
            return false
        }
        catch {
            return false
        }

    }
    
    func refresh() -> AnyPublisher<RefreshTokenResponse, Error> {
        let parameters: [String: Any] = [
            "refresh_token": currentToken?.refresh_token ?? ""
        ]
        return SendPublisher("\(baseApi)/auth/refresh", method: "POST", parameters: parameters) as AnyPublisher<RefreshTokenResponse, Error>
    }
        
//        let publisher = SendPublisher("\(baseApi)/auth/refresh", method: "POST", parameters: parameters) as AnyPublisher<RefreshTokenResponse, Error>
//        _ = publisher.sink { completion in
//            switch completion {
//            case .failure(let error):
//                self.currentToken = nil
//                print(error)
//            case .finished:
//                print("finished")
//            }
//        } receiveValue: { token in
//            self.currentToken = token

    
    func DriverGetInfo() async -> DriverInfo? {
        do {
            return try await Send("\(baseApi)/driver", method: "GET") as DriverInfo?
        }
        catch {
            return nil
        }
    }
    
    func GetDriver() -> AnyPublisher<DriverInfo, Error> {
        return SendPublisher("\(baseApi)/driver", method: "GET") as AnyPublisher<DriverInfo, Error>
    }
    
    func AlarmSystemGetInfo() async -> AlarmSystem? {
        do {
            return try await Send("\(baseApi)/driver/auto/as_params", method: "GET") as AlarmSystem?
        }
        catch {
            return nil
        }
    }
    
    func GetAlarmSystem() -> AnyPublisher<AlarmSystem, Error> {
        return SendPublisher("\(baseApi)/driver/auto/as_params", method: "GET") as AnyPublisher<AlarmSystem, Error>
    }
    
    func GetReplacementParameters() async -> ReplacementParametersResponse? {
        do {
            return try await Send("\(baseApi)/driver/auto/replacement_parameters", method: "GET") as ReplacementParametersResponse?
        }
        catch {
            return nil
        }
    }
    
    func GetReplacements() -> AnyPublisher<ReplacementParametersResponse, Error> {
        return SendPublisher("\(baseApi)/driver/auto/replacement_parameters", method: "GET") as AnyPublisher<ReplacementParametersResponse, Error>
    }
    
    private func Send<T: Decodable>(_ url: String, method: String, parameters: [String: Any]? = nil) async throws -> T? {
        let url: URL = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        var headers: [String: String]
        if (currentToken?.access_token == nil) {
            headers = [
                "Content-Type": "application/json"
            ]
        } else {
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(self.currentToken?.access_token ?? "")",
            ]
        }
        
        request.allHTTPHeaderFields = headers
        do {
            var payload = Data()
            if parameters != nil {
                payload = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            }
            let (data, _) = try await URLSession.shared.upload(for: request, from: payload)
            print(data.debugDescription)
            let info = try JSONDecoder().decode(T.self, from: data)
            return info
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    public func RefreshPublisher() -> AnyPublisher<Bool, Error> {
        var request = URLRequest(url: URL(string: "\(baseApi)/auth/refresh")!)
        request.httpMethod = "POST"
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
            .map { element -> Bool in
                self.currentToken = element
                return true
            }
            .eraseToAnyPublisher()
        
    }
    
    private func RefreshPublisher1() -> AnyPublisher<(Data, URLResponse), Error> {
        var request = URLRequest(url: URL(string: "\(baseApi)/auth/refresh")!)
        request.httpMethod = "POST"
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { (data, response) -> (Data, URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return (data, response)
            }
//            .decode(type: RefreshTokenResponse.self, decoder: JSONDecoder())
//            .map { element -> Bool in
//                self.currentToken = element
//                return true
//            }
            .eraseToAnyPublisher()
        
    }
    
    private func SendPublisher<T: Decodable>(_ url: String, method: String, parameters: [String: Any]? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                    .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        var headers: [String: String]
        if (currentToken?.access_token == nil) {
            headers = [
                "Content-Type": "application/json"
            ]
        } else {
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(self.currentToken?.access_token ?? "")",
            ]
        }
        
        request.allHTTPHeaderFields = headers
        
        if parameters != nil {
            do {
                let payload = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                request.httpBody = payload
            }
            catch {
                return Fail(error: APIError.invalidRequestError("URL invalid"))
                    .eraseToAnyPublisher()
            }
        }
        
        //let refreshToken = RefreshPublisher1()
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
//        return publisher
//            .map { (data, response) -> AnyPublisher<(Data, URLResponse), Error> in
//                 let result = ((response as? HTTPURLResponse)?.statusCode == 401 && self.currentToken?.refresh_token != nil) ?
//                    refreshToken.map { _ in
//                        publisher
//                    }
//                    .switchToLatest()
//                    .eraseToAnyPublisher()
//
//                : Just((data, response)).eraseToAnyPublisher()
//                return result
////                if (false) {
////                    return Fail(error: Error("asd"))
////                }
////                Just((data, response)).eraseToAnyPublisher()
//
//            }
//            .switchToLatest()
//            .decode(T.self, from: JSONDecoder())
//            .mapError { error -> APIError in
//                return APIError.networkError(error: error)
//            }
//            .eraseToAnyPublisher()
            
            
            //.eraseToAnyPublisher()
        return publisher
                .mapError { error -> Error in
                        return APIError.transportError(error)
                      }
                .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                    let decoder = JSONDecoder()
                    guard let urlResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }

                    if !((200..<300) ~= urlResponse.statusCode) {
                        if urlResponse.statusCode == 400 {
                            let apiError = try decoder.decode(BadRequestResponse.self, from: data)
                            throw APIError.validationError(apiError.error)
                        }
//                        if (urlResponse.statusCode == 401 && self.currentToken?.refresh_token != nil) {
//                            RefreshPublisher()
//                                .map { _ in
//                                    publisher
//                                  }
//                                  .switchToLatest()
//                                  .eraseToAnyPublisher()
//                        }
                    }

                    return (data, response)
                }
                //.retry(3)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                //.share()
                //.delay(for: 5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
            
            
    
    }
}
