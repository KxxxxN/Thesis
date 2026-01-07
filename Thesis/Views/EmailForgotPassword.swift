//
//  EmailForgotPassword.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//

import SwiftUI

struct EmailForgotPassword: View {
    
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("ลืมรหัสผ่าน")
                        .font(.noto(25, weight: .bold))
                    HStack { //เปิด Hstack1
                        BackButton()
                        
                        Spacer()
                    }//ปิด Hstack1
                }//ปิด Zstack1
                .padding(.bottom)
                
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.emailForgotPassword,
                    isValid: .constant(viewModel.emailErrorForgot == nil),
                    errorMessage: viewModel.emailErrorForgot ?? ""
                )
                .onChange(of: viewModel.emailForgotPassword) {
                    // ใช้ ValidationHelper ตรวจสอบตามเงื่อนไข
                    if ValidationHelper.isEmpty(viewModel.emailForgotPassword) {
                        viewModel.emailErrorForgot = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
                    } else {
                        // ถ้าถูกต้อง ให้ล้างข้อความ Error
                        viewModel.emailErrorForgot = nil
                    }
                }
                
                
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        viewModel.forgotPassword()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top)
                
                Spacer()
                
            }//ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                OTPConfirmView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EmailForgotPassword()
}
