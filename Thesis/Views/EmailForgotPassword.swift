//
//  EmailForgotPassword.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//

import SwiftUI

struct EmailForgotPassword: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("ลืมรหัสผ่าน")
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
                
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.emailForgotPassword,
                    isValid: .constant(viewModel.emailErrorForgot == nil),
                    errorMessage: viewModel.emailErrorForgot ?? ""
                )
                .onChange(of: viewModel.emailForgotPassword) {
                    // Live validation
                    let currentEmail = viewModel.emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // 1. ตรวจสอบว่าช่องไม่ว่างเปล่า
                    if !currentEmail.isEmpty {
                        viewModel.emailErrorForgot = nil
                    } else {
                        viewModel.emailErrorForgot = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
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
        .navigationTitle("")
    }
}

#Preview {
    EmailForgotPassword()
}
