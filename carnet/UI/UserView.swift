//
//  UserView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 18.07.2022.
//

import SwiftUI

struct UserListItemView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .foregroundColor(.TextColorSecondary)
                    .font(.system(size: 16))
                Spacer()
            }
            HStack{
                Text(value)
                    .foregroundColor(.TextColorPrimary)
                    .font(.system(size: 21))
                Spacer()
            }
        }
    }
}

struct UserView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack{
            switch appState.driver {
            case let .loaded(driver):
                HStack {
                    Text(driver.driver.name)
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Text(driver.driver.phone_number)
                        .font(.system(size: 21))
                    Spacer()
                }
                HStack {
                    Text("Автомобиль")
                    Spacer()
                }
                .padding(.top, 40)
                List{
                    UserListItemView(title: "Госномер", value: driver.auto.main_info.state_number)
                    UserListItemView(title: "СТС", value: driver.auto.main_info.vrc_number)
                    UserListItemView(title: "VIN номер", value: driver.auto.main_info.vin_number)
                    UserListItemView(title: "Модель", value: driver.auto.main_info.model)
                    UserListItemView(title: "Год выпуска", value: String(driver.auto.main_info.release_year))
                    UserListItemView(title: "Цвет", value: driver.auto.main_info.color)
                    
                }
                .frame(maxHeight: 400)
                HStack {
                    Text("Автосервис")
                    Spacer()
                }
                .padding(.top, 24)
                List{
                    UserListItemView(title: "Любимый автосервис", value: driver.favorite_autoservice.autoservice_name)
                }
                .background(Color.BackgroundColor)
                .frame(maxHeight: 100)
                Spacer()
                Button(action: {
                    
                }) {
                    NavigationLink(destination: AboutView()) {
                        Text("О приложении")
                    }
                }.foregroundColor(.blue)
                    .disabled(true)
            case _:
                ProgressView()
            }
            
        }
        
        .background(Color.BackgroundColor)
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        return UserView()
            .environmentObject(AppState.Mock())
    }
}
