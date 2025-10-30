//
//  ContentView.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentCarouselIndex = 0
    
    let historyItems = [
        HistoryItem(title: "ขวดพลาสติก", date: "13/9/2025", points: "+3", pointsLabel: "คะแนน")
    ]
    
    let recyclableItems = [
        RecyclableItem(imageName: "Bottle", title: "ขวดพลาสติก", count: "33 ครั้ง"),
        RecyclableItem(imageName: "Plasticcup", title: "แก้วพลาสติก", count: "13 ครั้ง"),
        RecyclableItem(imageName: "Can", title: "กระป๋อง", count: "3 ครั้ง")
    ]
    
    let navigationItems = [
        NavigationItem(icon: "house.fill", label: "หน้าหลัก", isActive: true),
        NavigationItem(icon: "qrcode.viewfinder", label: "สแกน", isActive: false),
        NavigationItem(icon: "book", label: "ความรู้ทั่วไป", isActive: false),
        NavigationItem(icon: "person", label: "บัญชีผู้ใช้", isActive: false)
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Logo")
                    .font(.custom("Inter UI", size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 69)
                
                HStack(alignment: .center, spacing: 13) {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                    
                    HStack {
                        Text("สุนิสา จินดาวัฒนา")
                            .fontWeight(.bold)
                            .font(.custom("Inter UI", size: 20))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("333")
                                .font(.custom("Inter UI", size: 40))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("คะแนน")
                                .font(.custom("Inter UI", size: 15))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 205, alignment: .leading)
            .padding(.leading, 28)
            .background(Color.mainColor)
            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HistorySection(items: historyItems)
                    RewardExchangeSection()
                    FrequentWasteSection(items: recyclableItems)
                    WasteSeparationGuideSection(currentIndex: $currentCarouselIndex)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Inter", size: 18).weight(.bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text("ดูทั้งหมด")
                        .font(.custom("Inter", size: 14).weight(.medium))
                        .foregroundColor(Color(hex: "3b5131"))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "3b5131"))
                }
            }
        }
    }
}

struct HistorySection: View {
    let items: [HistoryItem]
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "ประวัติคะแนน")
            
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.custom("Inter", size: 20).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text(item.date)
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text(item.points)
                            .font(.custom("Inter", size: 25).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text(item.pointsLabel)
                            .font(.custom("Inter", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(Color(hex: "768572"))
                .cornerRadius(20)
            }
        }
    }
}

struct RewardExchangeSection: View {
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "แลกคะแนน")
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("300")
                            .font(.custom("Inter", size: 25).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text("คะแนน")
                            .font(.custom("Inter", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("แลกชั่วโมงจิตอาสาได้ 1 ชั่วโมง")
                        .font(.custom("Inter", size: 14).weight(.medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("แลกคะแนน")
                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(hex: "3b5131"))
                        .cornerRadius(20)
                }
            }
            .padding(16)
            .background(Color(hex: "768572"))
            .cornerRadius(20)
        }
    }
}

struct FrequentWasteSection: View {
    let items: [RecyclableItem]
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "ขยะที่แยกบ่อย")
            
            HStack(spacing: 8) {
                ForEach(items) { item in
                    RecyclableItemCard(item: item)
                        
                }
            }
        }
    }
}

struct RecyclableItemCard: View {
    let item: RecyclableItem
    
    var body: some View {
        VStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 92)
                .padding(.top, 8)
            
            Text(item.title)
                .font(.custom("Inter", size: 14).weight(.semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text(item.count)
                .font(.custom("Inter", size: 10).weight(.medium))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color(hex: "bcbfb1"))
        .cornerRadius(20)
    }
}

struct WasteSeparationGuideSection: View {
    @Binding var currentIndex: Int
    let totalPages = 3
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "วิธีการแยกขยะ")
            
            VStack(spacing: 12) {
                ZStack {
                    Color.white
                        .cornerRadius(20)
                    
                    Image("Solution1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 307, height: 136)
                }
                .frame(height: 150)
                .padding(8)
                .background(Color(hex: "bcbfb1"))
                .cornerRadius(20)
                
                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color(hex: "3b5131") : Color(hex: "bcbfb1"))
                            .frame(width: 9, height: 9)
                    }
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.bottomLeft, .bottomRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainAppView()
}
