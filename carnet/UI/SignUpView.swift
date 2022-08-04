////
////  SignUpView.swift
////  carnet
////
////  Created by Evgeniy Makhalin on 01.07.2022.
////
//
//import SwiftUI
//
//struct SignUpView: View {
//    @State var isAuth = false
//    @State var user = ""
//    @State var pass = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                Image("Logotip 1")
//                    .padding(.top, 104)
//                    .padding(.bottom, 100.0)
//                
//                VStack(alignment: .leading){
//                    
//                    HStack() {
//                        Text("Регистрация")
//                            .font(.body)
//                            .fontWeight(.bold)
//                    }
//                    TextField("Email", text: $user)
//                        .textFieldStyle(.roundedBorder)
//                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//                        .padding(.bottom, 16)
//                    SecureField("Пароль", text: $pass)
//                        .textFieldStyle(.roundedBorder)
//                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//                        .padding(.bottom, 16)
//                    SecureField("Повторите пароль", text: $pass)
//                        .textFieldStyle(.roundedBorder)
//                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//                        .padding(.bottom, 16)
//                    Button(action: {
//                        
//                    }) {
//                        Text("Зарегистрироваться")
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 46, maxHeight: 46, alignment: .center)
//                            .background(Color.blue)
//                            .foregroundColor(Color.white)
//                    }
//                    .cornerRadius(10)
//                      
//                }
//                .padding(.horizontal)
//                Spacer()
//                VStack{
//                    VStack {
//                        Text("Уже есть аккаунт?").foregroundColor(Color.gray.opacity(0.5))
//                        NavigationLink(destination: SignInView(isAuth: $isAuth)) {
//                            Text("Войти")
//                        }
//                    }.padding(.bottom, 32.0)
//                    
//                    Button(action: {
//                        
//                    }) {
//                        
//                        Text("О приложении")
//                        
//                    }.foregroundColor(.blue)
//                    
//                }
//            }
//        }
//        .navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
