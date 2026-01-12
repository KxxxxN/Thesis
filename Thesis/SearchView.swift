//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    
    @Binding var hideTabBar: Bool
    
    @State private var searchText = ""
    @State private var selectedTabnavigationItem = 2
    @State private var showBarcodeView = false
    @State private var showAiScanView = false
    
    @State private var selectedItem: String? = nil
    @State private var showDetailSearch = false

    
    
    let searchItems = [
        "ขวดพลาสติก",
        "กระป๋อง",
        "ซองขนม",
        "เศษอาหาร",
        "ตะเกียบไม้"
    ]
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return searchItems
        } else {
            return searchItems.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    headerView

                    SearchSection(
                        searchText: $searchText,
                        searchItems: filteredItems,
                        onSelectItem: { item in
                            selectedItem = item
                            hideTabBar = true
                            showDetailSearch = true
                        }
                    )
                    .padding(.top, 22)
                    .padding(.horizontal, 35)

                    Spacer()

                    AiScanBottomNavigationBar(
                        selectedTab: $selectedTabnavigationItem
                    ) { index in
                        hideTabBar = true
                        switch index {
                        case 0: showBarcodeView = true
                        case 1: showAiScanView = true
                        default: break
                        }
                    }
                    .padding(.horizontal, 47)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $showDetailSearch) {
                if selectedItem != nil {
                    DetailSearchView(
                        hideTabBar: $hideTabBar
                    )
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }

    // MARK: - Header
    var headerView: some View {
        HStack {
            BackButton()
            
            Spacer()
            
            Text("ค้นหา")
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Color.clear.frame(width: 25)
        }
        .padding(.trailing, 18)
        .padding(.top, 69)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 123)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top)
        )
        .edgesIgnoringSafeArea(.top)
    }
}

struct SearchSection: View {

    @Binding var searchText: String
    let searchItems: [String]
    var onSelectItem: (String) -> Void

    var body: some View {
        ZStack(alignment: .top) {

            RoundedRectangle(cornerRadius: 30)
                .fill(Color.searchColor)
                .frame(height: containerHeight)

            VStack(spacing: 0) {

                SearchBar(searchText: $searchText)

                VStack(spacing: 0) {
                    if searchItems.isEmpty {
                        Text("ไม่พบรายการที่ค้นหา")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(height: rowHeight)
                    } else {
                        ForEach(searchItems.indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                Button {
                                    onSelectItem(searchItems[index])
                                } label: {
                                    HStack {
                                        Text(searchItems[index])
                                            .font(.noto(16, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.vertical, 11)
                                }


                                if index < searchItems.count - 1 {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: searchItems.count)
    }

    // MARK: - Layout values
    private let rowHeight: CGFloat = 46
    private let searchBarHeight: CGFloat = 50
    private let verticalPadding: CGFloat = 20

    private var containerHeight: CGFloat {
        let itemCount = max(searchItems.count, 1)
        return searchBarHeight
             + (CGFloat(itemCount) * rowHeight)
             + verticalPadding
    }
}


struct SearchBar: View {

    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            TextField("ค้นหา", text: $searchText)
                .font(.noto(16))
                .padding(.leading, 23)

            Button { } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                    .frame(width: 37, height: 37)
            }
            .padding(.trailing, 23)
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.textFieldColor)
        )
    }
}
