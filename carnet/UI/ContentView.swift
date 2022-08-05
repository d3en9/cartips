//
//  ContentView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 02.07.2022.
//

import SwiftUI

struct ContentView: View {
//    @State var isAuth = UserDefaults.standard.value(forKey: "isAuth") as? Bool ?? false
    @StateObject private var appState = AppState()
    
    
    var body: some View {
        VStack{
            switch appState.state {
            case .authenticated:
                HomeView()
            default:
                SignInView()
            }
        }
        .environmentObject(appState)
//        .animation(.spring().repeatForever(autoreverses: false), value: isAuth)
//        .onAppear {
//            NotificationCenter.default.addObserver(forName: NSNotification.Name("isAuthChange"), object: nil, queue: .main) { (_) in
//
//                let isAuth = UserDefaults.standard.value(forKey: "isAuth") as? Bool ?? false
//                self.isAuth = isAuth
//            }
//        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.Mock())
    }
}
