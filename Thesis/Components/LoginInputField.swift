//
//  LoginInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: - Login Input
struct LoginInputField: View {
    let title : String
    let placeholder : String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 1. หัวข้อ
            Title(title: title)
            
            // 2. Input Field และปุ่ม (รวมอยู่ใน HStack)
            HStack {
                ZStack(alignment: .leading) {
                    PlaceholderView(text: text, placeholder: placeholder)
                    
                    // Logic สำหรับการสลับ TextField / SecureField
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    } else {
                        TextField("", text: $text)
                    }
                }
                .padding(.leading, 15)
                
                // ปุ่มสลับการมองเห็นรหัสผ่าน (แสดงเฉพาะเมื่อ isSecure เป็น true)
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle() } label: {
                        Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                    }
                }
            }
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor) // สมมติว่า Color.textFieldColor มีอยู่
            .cornerRadius(20)
            .modifier(ValidationBorder(isValid: isValid))
            
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .opacity(isValid ? 0 : 1)
            }
            .frame(height: 20, alignment: .top)
            .clipped()
            .padding(.leading, 7)
        }
    }
}
