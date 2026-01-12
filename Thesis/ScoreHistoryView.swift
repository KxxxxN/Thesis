//
//  ScoreHistoryView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//
import SwiftUI

struct ScoreItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let points: String
    let color: Color
}

struct ScoreHistoryView: View {
    @State private var currentPage = 0
    @Binding var hideTabBar: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Text("ประวัติคะแนน")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.white)

                    HStack {
                        BackButtonWhite()

                        Spacer()
                    }
                }
                .padding(.top, 65)

                HStack(alignment: .center, spacing: 13) {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(radius: 4)

                    HStack {
                        Text("สุนิสา จินดาวัฒนา")
                            .font(.noto(20, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("333")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            Text("คะแนน")
                                .font(.noto(15, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 28)
                }
                .padding(.top, 16)
                .padding(.leading, 28)
                .padding(.bottom, 30)
            }
            .frame(height: 205)
            .frame(maxWidth: .infinity)
            .background(
                Color.mainColor
                    .clipShape(
                        RoundedCorner(
                            radius: 20,
                            corners: [.bottomLeft, .bottomRight]
                        )
                    )
            )

            TabView {
                PageView()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
    }
}

struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.mainColor : Color.thirdColor)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct ScoreSortMenu: View {
    @Binding var items: [ScoreItem]
    @Binding var selectedSort: String
    @Binding var isDropdownOpen: Bool
    @Binding var currentPage: Int

    let menuItems = [
        "ใหม่ที่สุด", "เก่าที่สุด",
        "คะแนนมาก → น้อย", "คะแนนน้อย → มาก"
    ]

    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isDropdownOpen.toggle()
                }
            } label: {
                HStack(spacing: 2) {
                    Text("เรียงจาก")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(.mainColor)

                    Image(isDropdownOpen ? "IconSort2" : "IconSort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct PageView: View {
    @State private var currentPage = 0
    @State private var items: [ScoreItem]
    @State private var isDropdownOpen = false
    @State private var selectedSort = "ใหม่ที่สุด"
    
    let itemsPerPage = 7
    
    init() {
        let initialData: [ScoreItem] = [
            ScoreItem(title: "ขวดพลาสติก", date: "13/9/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "11/9/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "แลกคะแนน", date: "9/9/2025", points: "-300", color: .redeemColor),
            ScoreItem(title: "แก้วพลาสติก", date: "8/9/2025", points: "+2", color: .secondColor),
            ScoreItem(title: "กระป๋อง", date: "3/9/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ตะเกียบไม้", date: "28/8/2025", points: "+1", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "27/8/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "13/8/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "11/8/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "แก้วพลาสติก", date: "8/8/2025", points: "+2", color: .secondColor),
            ScoreItem(title: "แลกคะแนน", date: "9/8/2025", points: "-600", color: .redeemColor),
            ScoreItem(title: "กระป๋อง", date: "3/8/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ตะเกียบไม้", date: "1/8/2025", points: "+1", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "27/7/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "25/7/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "13/7/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ขวดพลาสติก", date: "11/7/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "แก้วพลาสติก", date: "8/7/2025", points: "+2", color: .secondColor),
            ScoreItem(title: "แลกคะแนน", date: "9/7/2025", points: "-600", color: .redeemColor),
            ScoreItem(title: "กระป๋อง", date: "3/7/2025", points: "+3", color: .secondColor),
            ScoreItem(title: "ตะเกียบไม้", date: "1/7/2025", points: "+1", color: .secondColor),
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        var sortedItems = initialData
        
        sortedItems.sort {
            let date1 = formatter.date(from: $0.date) ?? Date.distantPast
            let date2 = formatter.date(from: $1.date) ?? Date.distantPast
            return date1 > date2
        }

        _items = State(initialValue: sortedItems)
        _currentPage = State(initialValue: 0)
    }

    var body: some View {
        let totalPages = min((items.count - 1) / itemsPerPage, 2)

        VStack(spacing: 11) {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(spacing: 9) {
                        ScoreSortMenu(items: $items, selectedSort: $selectedSort, isDropdownOpen: $isDropdownOpen, currentPage: $currentPage)
                            .padding(.horizontal, 15)

                        ForEach(currentItems, id: \.id) { item in
                            ScoreCard(title: item.title,
                                      date: item.date,
                                      points: item.points,
                                      backgroundColor: item.color)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if isDropdownOpen {
                        withAnimation {
                            isDropdownOpen = false
                        }
                    }
                }
                
                if isDropdownOpen {
                    DropdownOverlay(
                        items: $items,
                        currentPage: $currentPage,
                        isOpen: $isDropdownOpen,
                        selectedSort: $selectedSort
                    )
                    .padding(.top, 0)
                    .padding(.trailing, 15)
                    .zIndex(999)
                }
            }
            .background(Color.white)
            .cornerRadius(20)

            CustomPaginationView(currentPage: $currentPage, maxPage: totalPages)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(10)
        }
    }

    var currentItems: [ScoreItem] {
        let start = currentPage * itemsPerPage
        let end = min(start + itemsPerPage, items.count)
        return Array(items[start..<end])
    }
}






