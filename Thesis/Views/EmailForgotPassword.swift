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
//        NavigationStack {
            VStack(spacing: 0){ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("ลืมรหัสผ่าน")
                        .font(.noto(25, weight: .bold))
                    HStack { //เปิด Hstack1
                        BackButton()
                        
                        Spacer()
                    }//ปิด Hstack1
                }//ปิด Zstack1
                .padding(.bottom, 30)
                
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.emailForgotPassword,
                    isValid: .constant(!viewModel.isForgotSubmitted || viewModel.emailErrorForgot == nil),
                    errorMessage: viewModel.isForgotSubmitted ? (viewModel.emailErrorForgot ?? "") : ""
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.emailForgotPassword) {
                    viewModel.clearError()
                }
                
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        Task {
                            await viewModel.forgotPassword()
                        }
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 40)
                
                Spacer()
                
            }//ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                // ส่ง email ไปยังหน้า OTP ด้วยเพื่อให้ User รู้ว่าส่งไปที่ไหน หรือใช้ในการ verify ต่อ
                OTPConfirmView(source: .forgotPassword, email: viewModel.emailForgotPassword)
            }
//        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EmailForgotPassword()
}
