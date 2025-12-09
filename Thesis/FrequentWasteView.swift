//
//  FrequentWasteView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct WasteItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let count: String
}

struct FrequentWasteView: View {

    @Environment(\.dismiss) var dismiss

    @State private var selectedWaste: WasteItem? = nil    

    let wasteItems = [
        WasteItem(imageName: "Bottle", title: "ขวดพลาสติก", count: "33 ครั้ง"),
        WasteItem(imageName: "Plasticcup", title: "แก้วพลาสติก", count: "13 ครั้ง"),
        WasteItem(imageName: "Can", title: "กระป๋อง", count: "3 ครั้ง"),
        WasteItem(imageName: "Foodscraps", title: "เศษอาหาร", count: "3 ครั้ง"),
        WasteItem(imageName: "Chips", title: "ซองขนม", count: "2 ครั้ง"),
        WasteItem(imageName: "Bag", title: "ถุงพลาสติก", count: "10 ครั้ง"),
        WasteItem(imageName: "Foambox", title: "กล่องโฟม", count: "11 ครั้ง"),
        WasteItem(imageName: "GlassBottle", title: "ขวดแก้ว", count: "5 ครั้ง"),
        WasteItem(imageName: "Egg", title: "เปลือกไข่", count: "3 ครั้ง"),
        WasteItem(imageName: "Straw", title: "หลอด", count: "3 ครั้ง"),
        WasteItem(imageName: "Spoon", title: "ช้อนพลาสติก", count: "2 ครั้ง"),
        WasteItem(imageName: "Stick", title: "ทิชชู่", count: "1 ครั้ง"),
        WasteItem(imageName: "Fruit", title: "เปลือกผลไม้", count: "2 ครั้ง"),
        WasteItem(imageName: "Box", title: "กล่องกระดาษ", count: "7 ครั้ง")
    ]

    var sortedWasteItems: [WasteItem] {
        wasteItems.sorted {
            extractNumber($0.count) > extractNumber($1.count)
        }
    }

    func extractNumber(_ text: String) -> Int {
        Int(text.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
    }

    @State private var currentPage = 1
    let itemsPerPage = 6

    var paginatedItems: [WasteItem] {
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, sortedWasteItems.count)
        return Array(sortedWasteItems[startIndex..<endIndex])
    }

    var totalPages: Int {
        Int(ceil(Double(sortedWasteItems.count) / Double(itemsPerPage)))
    }

    // MARK: - Header
    var headerView: some View {
        ZStack {
            Color.mainColor
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }

                Spacer()

                Text("ขยะที่แยกทั้งหมด")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.left")
                    .foregroundColor(.clear)
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 28)
            .padding(.top, 69)
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

    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {

                headerView

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {

                        ForEach(paginatedItems, id: \.self) { item in
                            WasteCardView(item: item)
                                .onTapGesture {
                                    selectedWaste = item    // ⭐ ไปหน้า WasteTypeView
                                }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 43)
                }

                paginationSection
            }
            .edgesIgnoringSafeArea(.top)
        }
        // ⭐ Navigation ไป WasteTypeView
        .navigationDestination(item: $selectedWaste) { item in
            WasteTypeView(hideTabBar: .constant(true))
                .navigationBarBackButtonHidden(true)
        }
    }
}


// MARK: - CARD
struct WasteCardView: View {
    let item: WasteItem

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.noto(14, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.count)
                    .font(.noto(12, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 20)
        }
        .frame(height: 215)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}
