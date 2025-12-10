//
//  ContactRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct ContactRow: View {
    let title: String
/*    let subtitle: String?*/ // อาจเพิ่มข้อมูลติดต่อย่อย
    let imageName: String // ไอคอนช่องทางติดต่อ
    let action: () -> Void // action เมื่อกด (เช่น เปิดเบราว์เซอร์/โทรศัพท์)

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Icon
                Image(imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 32)
                
                // Text และ Subtitle
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.noto(20, weight: .medium))
                        .foregroundColor(Color.black)
                    
//                    if let subtitle = subtitle {
//                        Text(subtitle)
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                    }
                }
                
                Spacer()
                
            }
            .padding(.trailing, 25) // ปรับ padding ขวาให้ไม่ติดขอบมาก
            .frame(height: 93) 
            .background(Color.accountSecColor)
        }
    }
}
