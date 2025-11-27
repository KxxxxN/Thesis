//
//  ScoreHistoryView.swift
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
                            // ... (ส่วนหัวข้อ unchanged)
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(.white)

                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            .padding(.leading, 18)

                            Spacer()
                        }
                    }
                    .padding(.top, 65)

                    // ... (ส่วนข้อมูลผู้ใช้ unchanged)
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
                .background(Color.backgroundColor)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear { hideTabBar = true }
            .onDisappear { hideTabBar = false }
        }
    }

// ... (PageIndicator struct unchanged)
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
    @State private var selectedItem = "ใหม่ที่สุด"
    @State private var isOpen = false
    @Binding var currentPage: Int

    let menuItems = [
        "ใหม่ที่สุด", "เก่าที่สุด",
        "คะแนนมาก → น้อย", "คะแนนน้อย → มาก"
    ]

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // ... (Dropdown button unchanged)
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isOpen.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Text("เรียงจาก")
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(.mainColor)

                    Image(isOpen ? "IconSort2" : "IconSort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                }
            }
            .buttonStyle(.plain)

            if isOpen {
                VStack(spacing: 0) {
                    ForEach(menuItems, id: \.self) { item in
                        Button {
                            selectedItem = item
                            sortItems()
                            withAnimation { isOpen = false }
                        } label: {
                            HStack {
                                Text(item)
                                    .font(.noto(16, weight: .medium))
                                    .foregroundColor(
                                        item == selectedItem ? .white : .mainColor
                                    )
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 40)
                            .background(
                                item == selectedItem
                                ? Color.mainColor
                                : Color.white
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 165, height: 160)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 5)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .animation(.easeInOut(duration: 0.15), value: isOpen)
        .padding(.top, 24)
        .padding(.horizontal, 16)
    }

    // MARK: - Helper Functions
    
    /// แปลง String วันที่ในรูปแบบ "d/M/yyyy" ให้เป็นวัตถุ Date เพื่อเปรียบเทียบ
    private func date(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    /// Helper function สำหรับการเรียงวันที่: ใหม่สุดไปเก่าสุด
    private func compareDatesNewestFirst(item1: ScoreItem, item2: ScoreItem) -> Bool {
        let date1 = date(from: item1.date) ?? Date.distantPast
        let date2 = date(from: item2.date) ?? Date.distantPast
        return date1 > date2 // ใหม่สุดไปเก่าสุด
    }
    
    /// แปลง String คะแนนที่มีเครื่องหมาย + หรือ - ให้เป็น Int ที่ถูกต้องสำหรับการเปรียบเทียบ
    private func cleanPoints(_ points: String) -> Int {
        let cleanString = points.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")
        return Int(cleanString) ?? 0
    }

    // MARK: - sortItems()
    private func sortItems() {
        switch selectedItem {
        case "ใหม่ที่สุด":
            // เรียงวันที่จากใหม่สุดไปเก่าสุด
            items.sort { date(from: $0.date) ?? Date.distantPast > date(from: $1.date) ?? Date.distantPast }
        case "เก่าที่สุด":
            // เรียงวันที่จากเก่าสุดไปใหม่สุด
            items.sort { date(from: $0.date) ?? Date.distantPast < date(from: $1.date) ?? Date.distantPast }

        case "คะแนนมาก → น้อย":
            items.sort { item1, item2 in
                let points1 = cleanPoints(item1.points)
                let points2 = cleanPoints(item2.points)

                if points1 != points2 {
                    return points1 > points2 // Primary sort: คะแนนมากไปน้อย
                } else {
                    // Secondary sort: หากคะแนนเท่ากัน ให้เรียงตามวันที่ ใหม่สุดไปเก่าสุด
                    return compareDatesNewestFirst(item1: item1, item2: item2)
                }
            }
        case "คะแนนน้อย → มาก":
            items.sort { item1, item2 in
                let points1 = cleanPoints(item1.points)
                let points2 = cleanPoints(item2.points)

                if points1 != points2 {
                    return points1 < points2 // Primary sort: คะแนนน้อยไปมาก
                } else {
                    // Secondary sort: หากคะแนนเท่ากัน ให้เรียงตามวันที่ ใหม่สุดไปเก่าสุด
                    return compareDatesNewestFirst(item1: item1, item2: item2)
                }
            }
        default: break
        }
        
        // รีเซ็ตกลับไปที่หน้าแรกหลังจากเรียงข้อมูล
        currentPage = 0
    }
}

// ... (PageView, ScorePaginationView, CustomPaginationView, ScoreCard structs unchanged)
struct PageView: View {
    @State private var currentPage = 0
    @State private var items: [ScoreItem]
    
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
            ScoreItem(title: "ขวดพลาสติก", date: "27/6/2025", points: "+3", color: .secondColor),
        ]
        
        // สร้าง DateFormatter ภายใน init/Helper
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // 1. ทำสำเนาข้อมูลเริ่มต้น
        var sortedItems = initialData
        
        // 2. เรียงตาม "ใหม่ที่สุด" ทันที (Date ล่าสุด > Date เก่าสุด)
        sortedItems.sort {
            let date1 = formatter.date(from: $0.date) ?? Date.distantPast
            let date2 = formatter.date(from: $1.date) ?? Date.distantPast
            return date1 > date2
        }

        // กำหนดค่าเริ่มต้นให้กับ @State items ที่ถูกเรียงแล้ว
        _items = State(initialValue: sortedItems)
        _currentPage = State(initialValue: 0)
    }

    var body: some View {
        let totalPages = (items.count - 1) / itemsPerPage

        VStack(spacing: 9) {
            // ScoreSortMenu สำหรับเรียงข้อมูล
            ScoreSortMenu(items: $items, currentPage: $currentPage)

            ScrollView {
                VStack(spacing: 9) {
                    ForEach(currentItems, id: \.id) { item in
                        ScoreCard(title: item.title,
                                    date: item.date,
                                    points: item.points,
                                    backgroundColor: item.color)
                    }

                    // Pagination
                    CustomPaginationView(currentPage: $currentPage, maxPage: totalPages)
                        .padding(.top, 11)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 26)
            }
        }
    }

    // คืนข้อมูลเฉพาะหน้าปัจจุบัน
    var currentItems: [ScoreItem] {
        let start = currentPage * itemsPerPage
        let end = min(start + itemsPerPage, items.count)
        return Array(items[start..<end])
    }
}


struct ScorePaginationView: View {
    @Binding var currentPage: Int
    let totalPages: Int

    var body: some View {
        HStack(spacing: 20) {

            // ปุ่มย้อนหน้า
            Button(action: {
                if currentPage > 0 { currentPage -= 1 }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.mainColor)
            }

            Text("หน้า \(currentPage + 1) / \(totalPages + 1)")
                .font(.noto(16, weight: .medium))
                .foregroundColor(.mainColor)

            // ปุ่มถัดหน้า
            Button(action: {
                if currentPage < totalPages { currentPage += 1 }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.mainColor)
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
    }
}


struct CustomPaginationView: View {
    @Binding var currentPage: Int
    let maxPage: Int

    var pageNumbers: [Int] {

        let actualTotalPages = maxPage + 1
        let pagesToShow = min(actualTotalPages, 3)
        
        return Array(1...pagesToShow)
    }

    var body: some View {
        HStack(spacing: 8) {

            Button(action: {
                if currentPage > 0 {
                    currentPage -= 1
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(currentPage > 0 ? .mainColor : .gray)
            }
            .disabled(currentPage == 0)

            HStack(spacing: 16) {
                ForEach(pageNumbers, id: \.self) { page in
                    ZStack {
                        let isSelected = page == currentPage + 1
                        
                        if isSelected {
                            Circle()
                                .fill(Color.mainColor)
                                .frame(width: 30, height: 30)
                        }

                        Text("\(page)")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(isSelected ? .white : .mainColor)
                    }
                    .onTapGesture {
                        if page - 1 <= maxPage {
                            currentPage = page - 1
                        }
                    }
                }
            }
            
            Button(action: {
                if currentPage < maxPage {
                    currentPage += 1
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(currentPage < maxPage ? .mainColor : .gray)
            }
            .disabled(currentPage == maxPage)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ScoreCard: View {
    let title: String
    let date: String
    let points: String
    let backgroundColor: Color

    var body: some View {
        HStack {
            // ข้อความด้านซ้าย (Title และ Date)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.noto(20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(date)
                    .font(.noto(14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()

            // ข้อความด้านขวา (Points)
            VStack(alignment: .trailing, spacing: 0) {
                Text(points)
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.white)

                Text("คะแนน")
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .frame(width: 410, height: 75)
        .background(backgroundColor)
        .cornerRadius(20)
    }
}
