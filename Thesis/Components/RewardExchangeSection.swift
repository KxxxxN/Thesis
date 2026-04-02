//
//  RewardExchangeSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//
import SwiftUI

struct RewardExchangeSection: View {
    
    @Binding var hideTabBar: Bool
    
    // 1. ตรวจสอบ Size Class
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        let isIPad = horizontalSizeClass == .regular
        
        // 2. กำหนดตัวแปรสำหรับขนาดต่างๆ เพื่อลดความซ้ำซ้อนในโค้ด
        let vStackSpacing: CGFloat = isIPad ? 12 : 7
        let headerFontSize: CGFloat = isIPad ? 24 : 18
        let textSpacing: CGFloat = isIPad ? 6 : 3
        let pointsFontSize: CGFloat = isIPad ? 36 : 25
        let pointsLabelFontSize: CGFloat = isIPad ? 20 : 15
        let subtitleFontSize: CGFloat = isIPad ? 18 : 14
        let buttonFontSize: CGFloat = isIPad ? 20 : 16
        let buttonHPadding: CGFloat = isIPad ? 24 : 16
        let buttonVPadding: CGFloat = isIPad ? 14 : 10
        let buttonCornerRad: CGFloat = isIPad ? 25 : 20
        let cardPadding: CGFloat = isIPad ? 24 : 16
        let cardHeight: CGFloat = isIPad ? 110 : 75
        let cardCornerRad: CGFloat = 20
        
        VStack(spacing: vStackSpacing) {

            HStack {
                Text("แลกคะแนน")
                    .font(.noto(headerFontSize, weight: .bold))
                    .foregroundColor(.black)

                Spacer()
            }

            NavigationLink {
                RewardExchangeView(hideTabBar: $hideTabBar)
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: textSpacing) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("300")
                                .font(.system(size: pointsFontSize, weight: .bold))
                                .foregroundColor(.white)

                            Text("คะแนน")
                                .font(.noto(pointsLabelFontSize, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text("แลกชั่วโมงจิตอาสาได้ 1 ชั่วโมง")
                            .font(.noto(subtitleFontSize, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("แลกคะแนน")
                        .font(.noto(buttonFontSize, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, buttonHPadding)
                        .padding(.vertical, buttonVPadding)
                        .background(Color.mainColor)
                        .cornerRadius(buttonCornerRad)
                }
                .padding(cardPadding)
                .frame(maxWidth: .infinity) // ยืดให้เต็มกรอบที่ Parent View กำหนดไว้
                .frame(height: cardHeight)
                .background(Color.secondColor)
                .cornerRadius(cardCornerRad)
            }
            .buttonStyle(.plain)
        }
    }
}
