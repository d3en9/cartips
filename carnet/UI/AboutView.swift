//
//  AboutView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 02.07.2022.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack{
            List {
                NavigationLink(destination: ConfidentialView()) {
                    Text("Политика конфиденциальности")
                }
            }
            .listStyle(.sidebar)
        }
// trick from
// https://stackoverflow.com/a/62854805
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(
//              leading: Button(action: { presentation.wrappedValue.dismiss() }) {
//                Image(systemName: "chevron.left")
//                  .foregroundColor(.blue)
//                  .imageScale(.large) })
//        .gesture(
//              DragGesture(coordinateSpace: .local)
//                .onEnded { value in
//                  if value.translation.width > .zero
//                      && value.translation.height > -30
//                      && value.translation.height < 30 {
//                    presentation.wrappedValue.dismiss()
//                  }
//                }
//            )
        
        .background(Color.BackgroundColor)
        .navigationTitle("Условия пользования")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
