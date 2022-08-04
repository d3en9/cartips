//
//  AlarmView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 14.07.2022.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            
            HStack(){
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image("dismiss")
                        .renderingMode(.template)
                        .foregroundColor(.TextColorPrimary)
                }
                .padding()
            }
            
            HStack{
                switch appState.driver {
                case let .loaded(driver):
                    Text("Сигнализация \(driver.auto.alarm_system)")
                        .padding()
                case _:
                    ProgressView()
                }
                Spacer()
            }
            .padding(0)
            switch appState.alarmSystem {
            case let .loaded(alarmSystem):
                List(alarmSystem.parameters){alarm in
                    HStack{
                        Text(alarm.description)
                        Spacer()
                        Text("\(alarm.value)\(alarm.unit)")
                    }
                    
                }
                .padding(0)
            case _:
                ProgressView()
            }
            
        }
        .background(Color.BackgroundColor)
    }
}

struct AlarmView_Previews: PreviewProvider {
    static let alarms: [AlarmSystemParam]? = [
        AlarmSystemParam(name: "Test", description: "String", value: "String", unit: "String", active: true),
        AlarmSystemParam(name: "Test", description: "String", value: "String", unit: "String", active: true)
    ]
    static let alarmSystemName: String? = "Zont"
    
    static var previews: some View {
        AlarmView(isPresented: Binding.constant(true))
            .environmentObject(AppState.Mock())
    }
}
