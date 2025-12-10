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
    let imageName: String
}

struct WasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    @State private var currentPage = 1

    let wasteItems: [WasteTypeItem] = [
        WasteTypeItem(title: "ขวดพลาสติก", date: "13/9/2025", imageName: "TypeBottle1"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "11/9/2025", imageName: "TypeBottle2"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "10/9/2025", imageName: "TypeBottle3"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "9/9/2025", imageName: "TypeBottle4"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "1/9/2025", imageName: "TypeBottle5"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "20/8/2025", imageName: "TypeBottle1"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "27/8/2025", imageName: "TypeBottle2"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "11/8/2025", imageName: "TypeBottle3"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "13/8/2025", imageName: "TypeBottle4"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "1/8/2025", imageName: "TypeBottle5"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "13/7/2025", imageName: "TypeBottle1"),
        WasteTypeItem(title: "ขวดพลาสติก", date: "11/7/2025", imageName: "TypeBottle2"),
    ]

    var sortedWasteItems: [WasteTypeItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        return wasteItems.sorted {
            guard let d1 = formatter.date(from: $0.date),
                  let d2 = formatter.date(from: $1.date) else { return false }
            return d1 > d2
        }
    }

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                headerView
                
                ScrollView {
                    VStack(spacing: 11) {
                        let itemsPerPage = 5
                        let startIndex = (currentPage - 1) * itemsPerPage
                        let endIndex = min(startIndex + itemsPerPage, sortedWasteItems.count)

                        ForEach(sortedWasteItems[startIndex..<endIndex]) { item in
                            NavigationLink(destination: DetailView(hideTabBar: $hideTabBar)) {
                                WasteItemCard(
                                    title: item.title,
                                    date: item.date,
                                    imageName: item.imageName,
                                    cardColor: Color.wasteCard
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
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .navigationBarHidden(true)
    }
    
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

                Text("ขยะแต่ละประเภท")
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
            let itemsPerPage = 5
            let totalPages = Int(ceil(Double(sortedWasteItems.count) / Double(itemsPerPage)))

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
    let imageName: String
    let cardColor: Color

    var body: some View {
        HStack(spacing: 49) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 92)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 30))

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
