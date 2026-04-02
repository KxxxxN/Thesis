//
//  WasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//


import SwiftUI

struct WasteTypeItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let imageUrl: String?
}

struct WasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    @State private var currentPage = 1
    let category: String
    @StateObject private var vm = WasteTypeViewModel()

    let itemsPerPage = 5

    var totalPages: Int {
        max(1, Int(ceil(Double(vm.items.count) / Double(itemsPerPage))))
    }

    var pagedItems: [WasteTypeItem] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, vm.items.count)
        guard start < end else { return [] }
        return Array(vm.items[start..<end])
    }

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                headerView
                    if vm.items.isEmpty {
                        // ✅ Empty State เหมือน ScoreHistoryView
                        Spacer()
                        VStack(spacing: 0) {
                            Image("ListEmpty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)

                            Text("ไม่มีประวัติการแยกขยะ")
                                .font(.noto(25, weight: .bold))
                                .foregroundColor(.textFieldColor)

                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 11) {
                                ForEach(pagedItems) { item in
                                    NavigationLink(destination: DetailView(hideTabBar: $hideTabBar)) {
                                        WasteItemCard(
                                            title: item.title,
                                            date: item.date,
                                            imageUrl: item.imageUrl
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 42)
                            .padding(.bottom, 125)
                        }

                        paginationSection
                    }
                }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarHidden(true)
        .task {
            await vm.fetchItems(category: category) // ✅ โหลดตาม category
        }
    }
    
    var headerView: some View {
        ZStack {
            Color.mainColor

            ZStack {
//                Text(category)
                Text("ขยะแต่ละประเภท")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.white)

                HStack {
                    BackButtonWhite()

                    Spacer()
                }
            }
            .padding(.top, 69)
            .padding(.bottom, 28)
            .padding(.horizontal, 18)
        }
        .frame(height: 123)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    }


    var paginationSection: some View {
        HStack(spacing: 19) {
            Button(action: { if currentPage > 1 { currentPage -= 1 } }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(currentPage == 1 ? .gray : Color.mainColor)
                    .font(.system(size: 20))
            }
            .disabled(currentPage == 1)

            ForEach(1...totalPages, id: \.self) { page in
                Button(action: { currentPage = page }) {
                    Text("\(page)")
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(currentPage == page ? .white : Color.mainColor)
                        .frame(width: 30, height: 30)
                        .background(currentPage == page ? Color.mainColor : Color.clear)
                        .clipShape(Circle())
                }
            }

            Button(action: { if currentPage < totalPages { currentPage += 1 } }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(currentPage == totalPages ? .gray : Color.mainColor)
                    .font(.system(size: 20))
            }
            .disabled(currentPage == totalPages)
        }
    }
}

struct WasteItemCard: View {
    let title: String
    let date: String
    let imageUrl: String?
//    let cardColor: Color

    var body: some View {
        HStack(spacing: 49) {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.thirdColor
                }
                .frame(width: 140, height: 92)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.thirdColor)
                    .frame(width: 140, height: 92)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.noto(20, weight: .bold))
                    .foregroundColor(.black)
                
                Text(date)
                    .font(.noto(14, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 110)
        .background(Color.thirdColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
