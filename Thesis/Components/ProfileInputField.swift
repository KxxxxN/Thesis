//
//  ProfileInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//


import SwiftUI

struct ProfileInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var isInvalid: Bool
    var errorMessage: String
    var keyboardType: UIKeyboardType = .default
    var onEditingChanged: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 4) { // ใช้ spacing 5 เหมือน LoginInputField
            // 1. หัวข้อ
            Title(title: title)
            
            // 2. ส่วนของ Input / Text
            HStack {
                ZStack(alignment: .leading) {
                    if isEditing {
                        // เพิ่ม PlaceholderView เพื่อให้เหมือน Login/Register
                        PlaceholderView(text: text, placeholder: placeholder)
                        
                        TextField("", text: $text)
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                            .keyboardType(keyboardType)
                            .onChange(of: text) { oldValue, newValue in
                                onEditingChanged()
                            }
                    } else {
                        // โหมดดูอย่างเดียว
                        Text(text.isEmpty ? "ไม่ได้ระบุ" : text)
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.leading, 15)
                
                Spacer()
                
                // ปุ่ม Pencil แสดงเฉพาะโหมดแก้ไข
                if isEditing {
                    Image(systemName: "pencil")
                        .foregroundColor(.mainColor)
                        .frame(width: 16, height: 18)
                        .padding(.trailing, 15)
                }
            }
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            // ใช้ความสามารถของ ValidationBorder
            .modifier(ValidationBorder(isValid: isEditing ? (!text.isEmpty && !isInvalid) : true))
            
            // 3. ส่วนแสดงข้อความ Error (โครงสร้างเดียวกับ Login/Register)
            Group {
                // จองพื้นที่ 20 ไว้เสมอไม่ว่าจะโหมดไหน Layout จะได้ไม่ขยับ
                Text(isEditing && (text.isEmpty || isInvalid) ?
                     (text.isEmpty ? "กรุณากรอก\(title)" : errorMessage) : "")
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .padding(.top,3)
                    .opacity(isEditing && (text.isEmpty || isInvalid) ? 1 : 0)
            }
            .frame(height: 20, alignment: .top)
            .clipped()
            .padding(.leading, 7)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileEmailField: View {
    let title: String
    let email: String
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Title(title: title)
            
            Group {
                if isEditing {
                    // โหมดแก้ไข: เป็น NavigationLink ไปหน้ายืนยันรหัสผ่าน
                    NavigationLink(destination: ConfirmPasswordView()) {
                        HStack {
                            Text(email)
                                .font(.noto(20, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "pencil")
                                .foregroundColor(.mainColor)
                                .frame(width: 16, height: 18)
                        }
                    }
                } else {
                    // โหมดดู: เป็น Text ธรรมดา
                    HStack {
                        Text(email)
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            
            Color.clear
                .frame(width: 345, height: 20)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfilePasswordField: View {
    let title: String
    let password: String
    @Binding var isEditing: Bool
    @Binding var isPasswordVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Title(title: title)
            
            Group {
                if isEditing {
                    // โหมดแก้ไข: กดแล้วไปหน้ายืนยันอีเมล/รหัสผ่านใหม่
                    NavigationLink(destination: ConfirmEmailView()) {
                        HStack {
                            Text(isPasswordVisible ? password : String(repeating: "•", count: password.count))
                                .font(.noto(20, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "pencil")
                                .foregroundColor(.mainColor)
                                .frame(width: 16, height: 18)
                        }
                    }
                } else {
                    // โหมดดู: มีปุ่มเปิด/ปิดตา
                    HStack {
                        Text(isPasswordVisible ? password : String(repeating: "•", count: 8)) // โชว์จุดคงที่เพื่อความปลอดภัย
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.mainColor)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            
            Color.clear
                .frame(width: 345, height: 20)
        }
        .frame(maxWidth: .infinity)
    }
}
