//
//  PullToRefreshView.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 05.08.2022.
//  copy from https://stackoverflow.com/a/65100922

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: () async->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        Task {
                            if needRefresh {
                                needRefresh = false
                                await onRefresh()
                            }
                        }
                        
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                }
                Spacer()
            }
        }
        .padding(.top, -50)
    }
}
