//
//  FormComponents.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//

// FormComponents.swift

import SwiftUI

// MARK: - Required Title Component
struct RequiredTitle: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.noto(20, weight: .bold))
            
            Text(" *")
                .font(.noto(20, weight: .bold))
                .foregroundColor(.red)
        }
    }
}

// MARK: - Placeholder View Helper
struct PlaceholderView: View {
    let text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.placeholderColor)
                    .font(.noto(18 , weight: .medium))
            }
            Spacer()
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Password Validation Checklist View
struct PasswordValidationChecklist: View {
    @ObservedObject var viewModel: RegisterViewModel // ต้องรับ ViewModel มาเพื่อเข้าถึง Password
    
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

// MARK: - View Modifier (ValidationBorder)
struct ValidationBorder: ViewModifier {
    let isValid: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    // สมมติว่า Color.errorColor มีอยู่จริงในโครงการ
                    .stroke(isValid ? Color.clear : Color.errorColor, lineWidth: isValid ? 0 : 2)
            )
    }
}

// MARK: - Input Field Component
struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "จำเป็นต้องระบุ"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
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
                    
                // ปุ่มแสดง/ซ่อนรหัสผ่าน
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
            .modifier(ValidationBorder(isValid: isValid)) // ใช้ Modifier ที่ถูกแยกออกมา
                 
            // ข้อความแสดงข้อผิดพลาด
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
            }
            .frame(height: !isValid ? 20 : 0, alignment: .top)
            .clipped()
        }
    }
}
