//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @State private var showAiScanView = false
    @State private var showSearchView = false
    
    @State private var selectedTabnavigationItem = 1
    
    var body: some View {
        Text("Hello, SearchView!")
        

    }
    
    var headerView: some View {
        HStack {
            BackButton()

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("ค้นหา")
                    .font(.noto(25, weight: .bold))

            }
            .foregroundColor(.black)

            Spacer()


        }
        .padding(.bottom, 15) // เว้นระยะห่างด้านล่างเนื้อหา
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top) // ให้สีพื้นหลังถมส่วน Notch/Status Bar
        )
    }
}


