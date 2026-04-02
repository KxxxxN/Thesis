//
//  HistorySection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/11/2568 BE.
//
import SwiftUI

struct HistorySection: View {
    
    @Binding var hideTabBar: Bool
    let items: [HistoryItem]
    
    // 1. ตรวจสอบ Size Class
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        let isIPad = horizontalSizeClass == .regular
        
        // 2. กำหนดตัวแปรสำหรับขนาดต่างๆ เพื่อลดความซ้ำซ้อนในโค้ด
        let titleFontSize: CGFloat = isIPad ? 24 : 20
        let subtitleFontSize: CGFloat = isIPad ? 18 : 14
        let pointFontSize: CGFloat = isIPad ? 36 : 25
        let pointLabelSize: CGFloat = isIPad ? 20 : 15
        let cardHeight: CGFloat = isIPad ? 110 : 75
        let cardPadding: CGFloat = isIPad ? 24 : 16
        let cornerRad: CGFloat = isIPad ? 25 : 20
        let vStackSpacing: CGFloat = isIPad ? 12 : 7
        let textSpacing: CGFloat = isIPad ? 6 : 3
        
        VStack(spacing: vStackSpacing) {
            SectionHeader(
                title: "ประวัติคะแนน",
                destinationView: ScoreHistoryView(hideTabBar: $hideTabBar)
            )
            
            if items.isEmpty {
                // ✅ Empty state card
                NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                    HStack {
                        VStack(alignment: .leading, spacing: textSpacing) {
                            Text("ยังไม่มีคะแนน?")
                                .font(.noto(titleFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!")
                                .font(.noto(subtitleFontSize, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("0")
                                .font(.system(size: pointFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("คะแนน")
                                .font(.noto(pointLabelSize, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, cardPadding)
                    .frame(maxWidth: .infinity) // ปรับให้ขยายเต็มพื้นที่ที่กำหนดใน MainAppView
                    .frame(height: cardHeight)
                    .background(Color.secondColor)
                    .cornerRadius(cornerRad)
                }
            } else {
                ForEach(items) { item in
                    NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                        HStack {
                            VStack(alignment: .leading, spacing: textSpacing) {
                                Text(item.title)
                                    .font(.noto(titleFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.date)
                                    .font(.system(size: subtitleFontSize, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                Text(item.points)
                                    .font(.system(size: pointFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.pointsLabel)
                                    .font(.noto(pointLabelSize, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, cardPadding)
                        .frame(maxWidth: .infinity) // ปรับให้ขยายเต็มพื้นที่ที่กำหนดใน MainAppView
                        .frame(height: cardHeight)
                        .background(Color.secondColor)
                        .cornerRadius(cornerRad)
                    }
                }
            }
        }
    }
}
