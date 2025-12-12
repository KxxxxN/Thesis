//
//  RegisterInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: - Input Field Component
struct RegisterInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "จำเป็นต้องระบุ"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RequiredTitle(title: title)
                 
            HStack {
                ZStack(alignment: .leading) {
                    PlaceholderView(text: text, placeholder: placeholder)
                    
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
                
                
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle() } label: {
                        Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            .modifier(ValidationBorder(isValid: isValid))
                 
            // ข้อความแสดงข้อผิดพลาด
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .frame(height: 20)
                    .padding(.top,3)
                    .opacity(isValid ? 0 : 1)
            }
            .clipped()
        }
    }
}

// MARK: - Password Validation Checklist View
struct PasswordValidatCheckRegister: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        let checkColor: Color = Color.mainColor
        let defaultColor: Color = Color.placeholderColor
        
        return VStack(alignment: .leading, spacing: 3) {
            Group {
                // เงื่อนไขที่ 1: ความยาว 8 ตัวอักษร
                HStack(spacing: 4) {
                    let passed = viewModel.hasMinimumLength(viewModel.password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("อย่างน้อย 8 ตัวอักษร")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                
                // เงื่อนไขที่ 2: ตัวอักษรพิมพ์ใหญ่
                HStack(spacing: 4) {
                    let passed = viewModel.hasUppercase(viewModel.password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวอักษรพิมพ์ใหญ่ อย่างน้อย 1 ตัว (A–Z)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                
                // เงื่อนไขที่ 3: ตัวอักษรพิมพ์เล็ก
                HStack(spacing: 4) {
                    let passed = viewModel.hasLowercase(viewModel.password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวอักษรพิมพ์เล็ก อย่างน้อย 1 ตัว (a–z)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                
                // เงื่อนไขที่ 4: ตัวเลข
                HStack(spacing: 4) {
                    let passed = viewModel.hasDigit(viewModel.password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวเลข อย่างน้อย 1 ตัว (0–9)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                
                // เงื่อนไขที่ 5: อักขระพิเศษ
                HStack(spacing: 4) {
                    let passed = viewModel.hasSpecialCharacter(viewModel.password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีอักขระพิเศษ อย่างน้อย 1 ตัว (!@#$%&*_- เป็นต้น)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
            }
            .font(.noto(14, weight: .medium))
        }
        .frame(width: 345, alignment: .leading)
    }
}

