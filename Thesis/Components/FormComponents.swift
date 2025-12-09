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

struct Title : View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.noto(20, weight: .bold))
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
//            .frame(height: 25, alignment: .top)
            .clipped()
        }
    }
}

// MARK: - Button Component

//PrimaryButton
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.noto(20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(Color.mainColor)
                .cornerRadius(20)
        }
    }
}

//SocialLoginButton
struct SocialLoginButton: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .font(.noto(18, weight: .medium)) // ใช้ Font ที่คุณกำหนด
                    .foregroundColor(.mainColor)
            }
            .padding(.leading, 54) // จัดตำแหน่งให้เป็นไปตาม Layout เดิม
            .frame(width: 345, height: 49, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainColor, lineWidth: 2)
            )
        }
    }
}

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

// MARK: - Otp Input
struct OTPInputView: View {
    @ObservedObject var viewModel: OTPConfirmViewModel
    
    @FocusState.Binding var focusedField: Int?
    
    private func borderColor(for index: Int) -> Color {
        if viewModel.isFieldInvalid[index] {
            return Color.errorColor
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $viewModel.otpFields[index])
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60, height: 75)
                    .background(Color.textFieldColor)
                    .cornerRadius(20)
                    .font(.noto(30, weight: .medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            // ใช้สถานะ isFieldInvalid จาก ViewModel
                            .stroke(borderColor(for: index), lineWidth: 2)
                    )
                    // ผูก focus state กับ index
                    .focused($focusedField, equals: index)
                    // ใช้ .onChange เพื่อจัดการ Logic ผ่าน ViewModel
                    .onChange(of: viewModel.otpFields[index]) { oldValue, newValue in
                        // เรียกใช้ฟังก์ชันใน ViewModel และส่ง focusedField เข้าไป
                        viewModel.handleOTPChange(index: index, newValue: newValue, focusedField: &focusedField)
                    }
            }
        }
    }
}

// MARK: - ChangePassword
struct ChangePasswordField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "กรุณากรอกรหัสผ่าน"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Title(title: title)
            
            HStack{
                ZStack(alignment: .leading){
                    PlaceholderView(text: text, placeholder: placeholder)
                    
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("",text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    } else {
                        TextField("", text: $text)
                    }
                }
                
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle()} label: {
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
//struct ChangePasswordField: View {
//    let title: String
//    let placeholder: String
//    @Binding var text: String
//    @Binding var isValid: Bool
//    var errorMessage: String = "จำเป็นต้องระบุ"
//    var isSecure: Bool = false
//    var isPasswordToggle: Binding<Bool>?
//
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // หัวข้อ
//            Text(title)
//                .font(.noto(20, weight: .bold))
//                .padding(.bottom, 5)
//
//            VStack(alignment: .leading, spacing: 5) {
//                HStack {
//                    // สลับระหว่าง TextField และ SecureField
//                    if isVisible {
//                        TextField(placeholder, text: $text)
//                            .textInputAutocapitalization(.never)
//                    } else {
//                        SecureField(placeholder, text: $text)
//                    }
//                    
//                    // ปุ่มสลับการมองเห็น (Eye Icon)
//                    Button {
//                        isVisible.toggle()
//                    } label: {
//                        Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
//                            .foregroundColor(.black)
//                    }
//                }
//                .padding()
//                .frame(height: 49)
//                .background(Color.textFieldColor)
//                .cornerRadius(20)
//                .overlay(
//                    // แสดงขอบแดงเมื่อมี Error
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(error != nil ? Color.errorColor : Color.clear, lineWidth: 2)
//                )
//
//                // แสดงข้อความ Error
//                if let error = error {
//                    Text(error)
//                        .font(.noto(14, weight: .medium))
//                        .foregroundColor(Color.errorColor)
//                        .padding(.leading, 10)
//                } else {
//                    // กำหนดความสูงสำรองเพื่อให้ layout ไม่กระโดด
//                    Text(" ")
//                        .font(.noto(14, weight: .medium))
//                        .hidden()
//                }
//            }
//        }
//        .frame(width: 345)
//    }
//}

struct PasswordValidatCheckChangePassword: View {
    @ObservedObject var viewModel: ChangePasswordViewModel
    
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
