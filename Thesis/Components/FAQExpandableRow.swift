//
//  FAQExpandableRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct FAQExpandableRow: View {
    let item: FAQItem
    let cornerRadiusValue: CGFloat = 20
    
    // สถานะการขยาย/ยุบของตัวเอง
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ปุ่มหลัก (คำถาม)
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
                print("FAQ Toggled: \(item.question)")
            }) {
                HStack(spacing: 0) {
                    // ใช้ String Interpolation เพื่อความกระชับ
                    Text("\(item.question)?")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.leading, 21)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                        
                    // ICON: เปลี่ยนไอคอนตามสถานะ isExpanded
                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
                .padding(.trailing)
                .frame(width: 410, height: 75)
                .background(Color.accountSecColor)
                // กำหนดมุมโค้งตามสถานะ
                .cornerRadius(cornerRadiusValue, corners: isExpanded ? [.topLeft, .topRight] : .allCorners)
            }
            
            // เนื้อหาที่ขยายลงมา (คำตอบ)
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.answer)
                        .font(.noto(16, weight: .regular))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                }
                .padding(.horizontal)
                .padding(.vertical)
                .frame(width: 410, alignment: .leading)
                .background(Color.accountSecColor)
                .cornerRadius(cornerRadiusValue, corners: [.bottomLeft, .bottomRight])
                .offset(y: -cornerRadiusValue)
            }
        }
        .padding(.bottom, isExpanded ? -cornerRadiusValue : 0)
    }
}
