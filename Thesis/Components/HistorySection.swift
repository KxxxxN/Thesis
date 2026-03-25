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
        VStack(spacing: 7) {
            SectionHeader(
                title: "ประวัติคะแนน",
                destinationView: ScoreHistoryView(hideTabBar: $hideTabBar)
            )
            
            if items.isEmpty {
                // ✅ Empty state card
                    NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("ยังไม่มีคะแนน?")
                                    .font(.noto(20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!")
                                    .font(.noto(14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                Text("0")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("คะแนน")
                                    .font(.noto(15, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: 410)
                        .frame(height: 75)
                        .background(Color.secondColor)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                    }
            } else {
                ForEach(items) { item in
                    NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(.noto(20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.date)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                Text(item.points)
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.pointsLabel)
                                    .font(.noto(15, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: 410)
                        .frame(height: 75)
                        .background(Color.secondColor)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

