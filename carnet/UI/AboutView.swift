//
//  AboutView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 02.07.2022.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: ConfidentialView()) {
                    Text("Политика конфиденциальности")
                }
            }
        }
        .navigationTitle("Условия пользования")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
