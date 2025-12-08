//
//  ChangePasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("เปลี่ยนรหัสผ่านใหม่")
                        .font(.noto(25, weight: .bold))
                    HStack { //เปิด Hstack1
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.leading, 18)
                        
                        Spacer()
                    }//ปิด Hstack1
                }//ปิด Zstack1
                .padding(.bottom)
                
                // --- 1. ช่องรหัสผ่านใหม่ ---
                ChangePasswordField(
                    title: "รหัสผ่าน",
                    placeholder: "กรุณากรอกรหัสผ่าน",
                    text: $viewModel.password,
                    isValid: $viewModel.isPasswordValid,
                    errorMessage: viewModel.password.isEmpty ?
                    "กรุณากรอกรหัสผ่าน" : "รูปแบบรหัสผ่านไม่ถูกต้อง",
                    isSecure: true,
                    isPasswordToggle: $viewModel.isConfirmPasswordVisible
                )
                .onChange(of: viewModel.password) {
                    if !viewModel.password.isEmpty {
                        viewModel.isPasswordValid = viewModel.isPasswordValid(password:viewModel.password)
                    }
                }
                
                if !viewModel.isPasswordValid(password: viewModel.password) {
                    PasswordValidatCheckChangePassword(viewModel: viewModel)
                        .padding(.top, -7)
                        .padding(.bottom, 5)
                }
                    
                ChangePasswordField(
                    title: "ยืนยันรหัสผ่าน",
                    placeholder: "กรุณายืนยันรหัสผ่าน",
                    text: $viewModel.confirmPassword,
                    isValid: $viewModel.isConfirmPasswordValid,
                    errorMessage: viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : "รหัสผ่านไม่ตรงกัน",
                    isSecure: true,
                    isPasswordToggle: $viewModel.isConfirmPasswordVisible
                )
                .onChange(of: viewModel.confirmPassword) {
                    if !viewModel.confirmPassword.isEmpty {
                        viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                    } else {
                        // หากช่องยืนยันว่างเปล่า ให้ถือว่าไม่ถูกต้อง
                        viewModel.isConfirmPasswordValid = false
                    }
                }
                // 💡 สิ่งที่ต้องเพิ่ม: ตรวจสอบเมื่อมีการเปลี่ยนแปลงในช่องรหัสผ่าน (Password)
                .onChange(of: viewModel.password) {
                    // บังคับให้ตรวจสอบความถูกต้องใหม่ หากช่องยืนยันรหัสผ่านถูกกรอกแล้ว
                    if !viewModel.confirmPassword.isEmpty {
                        viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                    }
                }
                
                Button(action: {
                    viewModel.changePassword()
                }) {
                    Text("ยืนยัน")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 155, height: 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                }
                .padding(.top, 55)
                
                Spacer()
                
            }//ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $viewModel.navigateToLogin) {
                LoginView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }

}

#Preview {
    ChangePasswordView()
}
