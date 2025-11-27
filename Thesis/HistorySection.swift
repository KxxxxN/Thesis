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
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "ประวัติคะแนน", destinationView: ScoreHistoryView(hideTabBar: $hideTabBar))

            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.noto(20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(item.date)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text(item.points)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(item.pointsLabel)
                            .font(.noto(15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(Color.secondColor)
                .cornerRadius(20)
            }
        }
    }
}
