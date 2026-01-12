//
//  NewPasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject private var viewModel = NewPasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationStack {
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text("ตั้งรหัสผ่านใหม่") // หัวข้อตามที่คุณต้องการ
                            .font(.noto(25, weight: .bold))
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // 1. ช่องรหัสผ่านปัจจุบัน
                    ChangePasswordField(
                        title: "รหัสผ่านเก่า",
                        placeholder: "กรอกรหัสผ่านปัจจุบัน",
                        text: $viewModel.oldPassword,
                        isValid: $viewModel.isOldPasswordValid,
                        errorMessage: viewModel.oldPassword.isEmpty ? "กรุณากรอกรหัสผ่าน" : "รหัสผ่านเดิมไม่ถูกต้อง",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isOldPasswordVisible
                    )
                    .padding(.bottom, 5)
                    .onChange(of: viewModel.oldPassword) { _, _ in
                        viewModel.clearErrorOnTyping(for: "old")
                    }
                    
                    // 2. ช่องรหัสผ่านใหม่
                    ChangePasswordField(
                        title: "รหัสผ่านใหม่",
                        placeholder: "อย่างน้อย 8 ตัวอักษร",
                        text: $viewModel.password,
                        isValid: $viewModel.isPasswordValid, // ✅ ใช้ Valid รายช่อง
                        errorMessage: viewModel.password.isEmpty ? "กรุณากรอกรหัสผ่าน" : "รูปแบบรหัสผ่านไม่ถูกต้อง",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isPasswordVisible
                    )
                    .onChange(of: viewModel.password) { _, _ in
                        viewModel.clearErrorOnTyping(for: "new") // ✅ ระบุว่าเป็นช่อง new
                        
                        // Logic ตรวจสอบความถูกต้องอื่นๆ ของคุณคงเดิม
                        if !viewModel.password.isEmpty {
                            viewModel.isPasswordValid = ValidationHelper.isPasswordValid(viewModel.password)
                        }
                        if !viewModel.confirmPassword.isEmpty {
                            viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                        }
                    }
                    
                    // Checklist แสดงเงื่อนไขรหัสผ่านใหม่
                    if !ValidationHelper.isPasswordValid(viewModel.password) {
                        PasswordValidationCheckView(password: viewModel.password)
                            .padding(.top,1)
                            .padding(.bottom, 7)
                    }
                    
                    // 3. ช่องยืนยันรหัสผ่านใหม่
                    ChangePasswordField(
                        title: "ยืนยันรหัสผ่านใหม่",
                        placeholder: "กรอกรหัสผ่านใหม่อีกครั้ง",
                        text: $viewModel.confirmPassword,
                        isValid: $viewModel.isConfirmPasswordValid,
                        errorMessage: viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : "รหัสผ่านไม่ตรงกัน",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible
                    )
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        viewModel.clearErrorOnTyping(for: "confirm")
                    }
                    
                    HStack(alignment: .bottom,spacing: 35){
                        SecondButton(title: "ยกเลิก", action: { dismiss() }, width: 155, height: 49)
                        
                        PrimaryButton(title: "บันทึก", action: { viewModel.saveNewPassword() }, width: 155, height: 49)
                    }
                    .padding(.top,20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: (viewModel.showSuccessAlert || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessAlert || viewModel.showErrorPopup)
            }
            .navigationBarBackButtonHidden(true)
            
            // MARK: Success Popup
            if viewModel.showSuccessAlert {
                SuccessPopupView(message: "เปลี่ยนรหัสผ่านสำเร็จ") {
                    withAnimation {
                        viewModel.showSuccessAlert = false
                        dismiss()
                    }
                }
            }
            
            // MARK: Error Popup
            if viewModel.showErrorPopup{
                ErrorPopupView(title: "เปลี่ยนรหัสผ่านไม่สำเร็จ"){
                    withAnimation {
                        viewModel.showErrorPopup = false
                    }
                }
            }
        }
    }
}

#Preview {
    NewPasswordView()
}
