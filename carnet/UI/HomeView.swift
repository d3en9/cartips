//
//  HomeView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 02.07.2022.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var showAlarms = false
    @State private var showReplacement = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack{
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        await appState.load()
                    }
                    HStack{
                        Image("attention")
                            .renderingMode(.template)
                            .hidden()
                        Spacer()
                        switch appState.driver {
                        case let .loaded(driver):
                            Text(driver.auto.main_info.model)
                                .foregroundColor(.TextColorPrimary)
                        case _:
                            ProgressView()
                        }
                        
                        Spacer()
                        Button(action: {
                            
                        }) {
                            NavigationLink(destination: UserView()) {
                                Image("user")
                                    .renderingMode(.template)
                            }
                        }
                        
                    }
                    .foregroundColor(.TextColorPrimary)
                    .padding(.bottom, 24)
                    
                    VStack{
                        HStack {
                            switch appState.driver {
                            case let .loaded(driver):
                                Text("Сигнализация \(driver.auto.alarm_system)")
                                    .foregroundColor(.TextColorPrimary)
                            case _:
                                ProgressView()
                            }
                            
                            Spacer()
                            Button(action: {
                                showAlarms = true
                            }) {
                                Image("settings")
                                    .renderingMode(.template)
                                    .foregroundColor(.TextColorSecondary)
                            }
                            .sheet(isPresented: $showAlarms){
                                AlarmView(isPresented: $showAlarms)
                            }
                        }
                        .padding()
                        
                        HStack {
                            switch appState.alarmSystem {
                            case let .loaded(alarmSystem):
                                ForEach(alarmSystem.parameters.prefix(3)){ alarm in
                                    VStack{
                                        Text(alarm.description)
                                            .foregroundColor(.TextColorSecondary)
                                            .multilineTextAlignment(TextAlignment.center)
                                            
                                        Text("\(alarm.value)\(alarm.unit)")
                                            .foregroundColor(.TextColorPrimary)
                                    }
                                    Spacer()
                                    
                                }
                            case _:
                                ProgressView()
                            }
                            
                        }
                        .padding()
                    }
                    .background(Color.BackgroundColorList)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    
                    Map(coordinateRegion: $appState.mapRegion, annotationItems: appState.markers) {  marker in
                        marker.location
                    }
                    .padding(.top, 23)
                    .frame(minHeight: 164, maxHeight: 164)
                    
                    VStack{
                        ZStack{
                            Group {
                                Spacer()
                                VStack {
                                    Text("Пробег")
                                        .foregroundColor(.TextColorSecondary)
                                    switch appState.driver {
                                    case let .loaded(driver):
                                        Text(String(driver.auto.mileage))
                                            .foregroundColor(.TextColorPrimary)
                                    case _:
                                        ProgressView()
                                    }
                                    
                                }
                                .padding()
                                Spacer()
                            }

                            HStack{
                                Spacer()
                                switch (appState.replacements){
                                case let .loaded(replacements):
                                    Button(action: {
                                        showReplacement = true
                                    }) {
                                        Image("settings")
                                            .renderingMode(.template)
                                            .foregroundColor(.TextColorSecondary)
                                            .padding()
                                    }
                                    .sheet(isPresented: $showReplacement){
                                        ReplacementView(isPresented: $showReplacement, replacements: replacements.replacement_parameters)
                                    }
                                case _:
                                    ProgressView()
                                }
                            }
                        }
                        HStack(alignment: .top) {
                            switch (appState.replacements){
                            case let .loaded(replacements):
                                Spacer()
                                VStack() {
                                    VStack{
                                        if (replacements.replacement_parameters.count > 0) {
                                            Text(replacements.replacement_parameters[0].unitValueMessage)
                                                .foregroundColor(.TextColorPrimary)
                                            Text(replacements.replacement_parameters[0].titleMessage)
                                                .foregroundColor(.TextColorSecondary)
                                                .multilineTextAlignment(TextAlignment.center)
                                        }
                                        
                                    }
                                    
                                    VStack{
                                        if (replacements.replacement_parameters.count > 2) {
                                            Text(replacements.replacement_parameters[2].unitValueMessage)
                                                .foregroundColor(.TextColorPrimary)
                                            Text(replacements.replacement_parameters[2].titleMessage)
                                                .foregroundColor(.TextColorSecondary)
                                                .multilineTextAlignment(TextAlignment.center)
                                        }
                                    }
                                    .padding(.top, 14)
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                VStack {
                                    VStack{
                                        if (replacements.replacement_parameters.count > 1) {
                                            Text(replacements.replacement_parameters[1].unitValueMessage)
                                                .foregroundColor(.TextColorPrimary)
                                            Text(replacements.replacement_parameters[1].titleMessage)
                                                .foregroundColor(.TextColorSecondary)
                                                .multilineTextAlignment(TextAlignment.center)
                                        }
                                    }
                                    VStack{
                                        if (replacements.replacement_parameters.count > 3) {
                                            Text(replacements.replacement_parameters[3].unitValueMessage)
                                                .foregroundColor(.TextColorPrimary)
                                            Text(replacements.replacement_parameters[3].titleMessage)
                                                .foregroundColor(.TextColorSecondary)
                                                .multilineTextAlignment(TextAlignment.center)
                                        }
                                    }
                                    .padding(.top, 14)
                                }
                                Spacer()
                            case _:
                                ProgressView()
                            }
                            
                        }
                    }
                    .frame(maxHeight: 270)
                    .background(Color.BackgroundColorList)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    .padding(.top, 24)
                    Spacer()
                }
                .background(Color.BackgroundColor)
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .padding(2)
            }
            .coordinateSpace(name: "pullToRefresh")
            .background(Color.BackgroundColor)
        }
        
        .onAppear {
            Task {
                await appState.load()
            }
//            appState.load()
        }
        .padding(13)
        .background(Color.BackgroundColor)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppState.Mock())
    }
}

