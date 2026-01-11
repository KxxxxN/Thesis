//
//  ChangePasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import SwiftUI

struct ChangePasswordView: View {
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack{ //เปิด Vstack1
                    ZStack { //เปิด Zstack1
                        Text("เปลี่ยนรหัสผ่านใหม่")
                            .font(.noto(25, weight: .bold))
                        HStack { //เปิด Hstack1
                            BackButton()
                            
                            Spacer()
                        }//ปิด Hstack1
                    }//ปิด Zstack1
                    .padding(.bottom)
                    
                    // --- 1. ช่องรหัสผ่านใหม่ ---
                    ChangePasswordField(
                        title: "รหัสผ่าน",
                        placeholder: "อย่างน้อย 8 ตัวอักษร",
                        text: $viewModel.password,
                        isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isPasswordValid),
                        errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isPasswordValid ? (viewModel.password.isEmpty ? "กรุณากรอกรหัสผ่าน" : "รูปแบบรหัสผ่านไม่ถูกต้อง") : "",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible
                    )
                    .onChange(of: viewModel.password) { _, _ in
                        viewModel.clearError(for: "password")
                        // ตรวจสอบ Confirm Password ใหม่ด้วยถ้ามีข้อมูลอยู่แล้ว
                        if !viewModel.confirmPassword.isEmpty {
                            viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                        }
                    }
                    
                    if !ValidationHelper.isPasswordValid(viewModel.password) {
                        PasswordValidationCheckView(password: viewModel.password)
                            .padding(.top, -7)
                            .padding(.bottom, 5)
                    }
                    
                    ChangePasswordField(
                        title: "ยืนยันรหัสผ่าน",
                        placeholder: "กรอกรหัสผ่านอีกครั้ง",
                        text: $viewModel.confirmPassword,
                        isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isConfirmPasswordValid),
                        errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isConfirmPasswordValid ? (viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : "รหัสผ่านไม่ตรงกัน") : "",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible
                    )
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        viewModel.clearError(for: "confirmPassword")
                    }

                    PrimaryButton(
                        title: "ยืนยัน", // Text ที่ต้องการแสดงบนปุ่ม
                        action: { // โค้ดการทำงานเมื่อกดปุ่ม
                            viewModel.changePassword()
                        },
                        width: 155, // ความกว้างของปุ่ม
                        height: 49 // ความสูงของปุ่ม
                    )
                    .padding(.top, 55)
                    
                    Spacer()
                    
                }//ปิด Vstack1
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
            }
            
            .navigationBarBackButtonHidden(true)
            
            if viewModel.showSuccessPopup {
                SuccessPopupView(message: "เปลี่ยนรหัสผ่านสำเร็จ") {
                    withAnimation {
                        viewModel.showSuccessPopup = false
                        viewModel.navigateToLogin = true // ✅ ย้ายหน้าหลังจากกดปิด Popup
                    }
                }
            }
            
            if viewModel.showErrorPopup {
                ErrorPopupView(
                    title: "ดำเนินการไม่สำเร็จ"
                ) {
                    withAnimation {
                        viewModel.showErrorPopup = false
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToLogin) {
            LoginView()
        }
    }
}

#Preview {
    ChangePasswordView()
}
