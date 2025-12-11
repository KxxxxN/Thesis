//
//  AccountMenuRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

struct AccountMenuRow<Destination: View>: View {
    let title: String
    let imageName: String
    let destination: Destination?
    let action: (() -> Void)?
    
    // Initializer สำหรับ NavigationLink (มีปลายทาง)
    init(title: String, imageName: String, destination: Destination) {
        self.title = title
        self.imageName = imageName
        self.destination = destination
        self.action = nil
    }
    
    // Initializer สำหรับ Button (ไม่มีปลายทาง)
    init(title: String, imageName: String, action: @escaping () -> Void) where Destination == EmptyView {
        self.title = title
        self.imageName = imageName
        self.action = action
        self.destination = nil
    }
    
    var rowContent: some View {
        HStack(spacing: 15) {
            Image(imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.leading, 35) // จัดระยะห่างตามโค้ดเดิม
            
            Text(title)
                .font(.noto(20, weight: .medium))
                .foregroundColor(Color.black)
            
            Spacer()
            
            // แสดง Chevron ถ้ามีปลายทาง (destination หรือ action ที่ไม่ใช่ Logout/Delete)
            if destination != nil || title == "แก้ไขโปรไฟล์" || title == "เปลี่ยนภาษา" || title == "ช่วยเหลือ" || title == "ติดต่อเรา" {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold))
            }
        }
        .padding(.trailing)
        .frame(height: 70) // ความสูงแถวตามโค้ดเดิม
        .background(Color.accountSecColor)
    }
    
    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination) {
                rowContent
            }
        } else if let action = action {
            Button(action: action) {
                rowContent
            }
        } else {
            rowContent
        }
    }
}

// MARK: - 2. Component: แถวเมนูที่มี Toggle (การแจ้งเตือน)
struct AccountToggleRow: View {
    let title: String
    let imageName: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            // สลับสถานะเมื่อกดที่ส่วนอื่นที่ไม่ใช่ Toggle
            isOn.toggle()
            print("\(title) toggled to \(isOn)")
        }) {
            HStack(spacing: 15) {
                Image(imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 35)
                
                Text(title)
                    .font(.noto(20, weight: .medium))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(.mainColor)
                    .fixedSize()
            }
            .padding(.trailing)
            .frame(height: 70)
            .background(Color.accountSecColor)
        }
    }
}
