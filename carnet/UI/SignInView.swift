//
//  ContentView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 27.06.2022.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appState: AppState

    @State var email = ""
    @State var password = ""
    @State var access_token = ""
    
    private func isAuthenticating() -> Bool {
        switch appState.state {
        case .authenticating: return true
        default: return false
        }
    }
    
    var body : some View{
        
        NavigationView {
            VStack {
                Spacer()
                Image("Logotip 1")
                    .padding(.bottom, 100.0)
                Spacer()
                VStack(alignment: .leading){
                    
                    HStack() {
                        Text("Вход")
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                        .padding(.bottom, 16)
                    
                    SecureField("Пароль", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                        .padding(.bottom, 16)
                    
                    Button(action: {
                        Task {
                            appState.state = .authenticating
                            do {
                                try await appState.signIn(email: email, password: password)
                                appState.state = .authenticated
                                appState.saveTokenInKeychain()
                                
                            }
                            catch let error where error is AuthError {
                                appState.state = .notAuth(error as? AuthError)
                            }
                            catch {
                                appState.state = .notAuth(.unexpectedError)
                            }
                            
                            
                        }
                    }) {
                        HStack {
                            Text("Войти")
                                .padding()
                            if isAuthenticating() {
                                ProgressView()
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 46, maxHeight: 46, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        
                    }
                    .cornerRadius(10)
                    
                    switch appState.state {
                    case let .notAuth(error):
                        if (error != nil) {
                            HStack{
                                Spacer()
                                Text(error!.localizedDescription)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        
                        }
                    default: Spacer()
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                Spacer()
                VStack{
                    Spacer()
                    //                    VStack {
                    //                        Text("Ещё нет аккаунта?").foregroundColor(Color.gray.opacity(0.5))
                    //                        NavigationLink(destination: SignUpView()) {
                    //                            Text("Зарегистрироваться")
                    //                        }
                    //                    }//.padding(.bottom, 32.0).hidden()
                    //                    Spacer()
                    Button(action: {
                        
                    }) {
                        NavigationLink(destination: AboutView()) {
                            Text("О приложении")
                        }
                    }.foregroundColor(.blue)
                        .disabled(true)
                    
                }
                Spacer()
            }
            .background(Color.BackgroundColor)
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("asd")
        .disabled(isAuthenticating())
    }
    
}

struct SignInView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignInView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(AppState.Mock())
    }
}
