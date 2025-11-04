//
//  RewardExchangeSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/11/2568 BE.
//
import SwiftUI

struct RewardExchangeSection: View {
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "แลกคะแนน")
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("300")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("คะแนน")
                            .font(.noto(15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("แลกชั่วโมงจิตอาสาได้ 1 ชั่วโมง")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("แลกคะแนน")
                        .font(.noto(16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                }
            }
            .padding(16)
            .background(Color.secondColor)
            .cornerRadius(20)
        }
    }
}
