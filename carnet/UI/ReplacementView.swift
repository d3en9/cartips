//
//  ReplacementView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 15.07.2022.
//

import SwiftUI

struct ReplacementView: View {
    @Binding var isPresented: Bool
    var replacements: [ReplacementParameter]
    
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
                Text("Данные об автомобиле".uppercased())
                    .padding()
                Spacer()
            }
            .padding(0)
            List(self.replacements){rep in
                HStack{
                    Text(rep.titleMessage)
                    Spacer()
                    Text(rep.unitValueMessage)
                }
                
            }
            .padding(0)
        }
        .background(Color.BackgroundColor)
    }
}

struct ReplacementView_Previews: PreviewProvider {
    static let replacements = replacementParametersMock.replacement_parameters
    
    static var previews: some View {
        ReplacementView(isPresented: Binding.constant(true), replacements: replacements)
            .environmentObject(AppState.Mock())
    }
}
