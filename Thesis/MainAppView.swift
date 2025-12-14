//
//  ContentView.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentCarouselIndex = 0
    @Binding var hideTabBar: Bool
    
    let historyItems = [
        HistoryItem(title: "ขวดพลาสติก", date: "13/9/2025", points: "+3", pointsLabel: "คะแนน")
    ]
    
    let recyclableItems = [
        RecyclableItem(imageName: "Bottle", title: "ขวดพลาสติก",countNumber: 33),
        RecyclableItem(imageName: "Plasticcup", title: "แก้วพลาสติก", countNumber: 13),
        RecyclableItem(imageName: "Can", title: "กระป๋อง", countNumber: 3)
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text("LOGO")
                    .font(.system(size: 24))
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
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 205)
            .frame(maxWidth: .infinity)
            .padding(.leading, 28)
            .background(Color.mainColor)
            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HistorySection(hideTabBar: $hideTabBar,items: historyItems)
                    RewardExchangeSection(hideTabBar: $hideTabBar)
                    FrequentWasteSection(hideTabBar: $hideTabBar, items: recyclableItems)
                    WasteSeparationGuideSection(currentIndex: $currentCarouselIndex, hideTabBar: $hideTabBar)
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundColor)
    }
}


struct SectionHeader<Destination: View>: View {
    let title: String
    let destinationView: Destination
    
    var body: some View {
        HStack {
            Text(title)
                .font(.noto(18, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            NavigationLink(destination: destinationView.navigationBarBackButtonHidden(true)) {
                HStack(spacing: 4) {
                    Text("ดูทั้งหมด")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(Color.mainColor)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color.mainColor)
                }
            }
        }
    }
}

struct FrequentWasteSection: View {
    
    @Binding var hideTabBar: Bool
    let items: [RecyclableItem]
    
    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(title: "ขยะที่แยกบ่อย", destinationView: FrequentWasteView())
            
            HStack(spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(destination: WasteTypeView(hideTabBar: $hideTabBar)) {
                        RecyclableItemCard(item: item)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct RecyclableItemCard: View {
    let item: RecyclableItem
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 92)
            
            VStack(spacing: 2) {
                Text(item.title)
                    .font(.noto(14, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("\(item.countNumber) ครั้ง")
                    .font(.noto(10, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}


struct WasteSeparationGuideSection: View {
    @Binding var currentIndex: Int
    @Binding var hideTabBar: Bool

    let totalPages = 3
    
    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(title: "วิธีการแยกขยะ", destinationView: KnowledgeView(hideTabBar: $hideTabBar))
            
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
                .background(Color.thirdColor)
                .cornerRadius(20)
                
                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.mainColor : Color.thirdColor)
                            .frame(width: 9, height: 9)
                    }
                }
            }
        }
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


