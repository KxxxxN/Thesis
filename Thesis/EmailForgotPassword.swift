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
    
    @State private var navigateToOTP: Bool = false
    
    private var isAnyError: Bool {
        return !viewModel.isEmailValid
    }

        // Logic ในการเลือกข้อความผิดพลาดที่ควรแสดง และจองพื้นที่
    private var currentErrorMessage: String {
        // 1. Server Error (Highest Priority)
        if let serverError = viewModel.serverErrorMessage, !serverError.isEmpty {
            return serverError
        }
        // 2. Client Error: Empty
        if viewModel.email.isEmpty {
            return "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
        }
        // 3. Client Error: Format
        if !viewModel.isValidEmail(email: viewModel.email) {
            return "รูปแบบอีเมลไม่ถูกต้อง"
        }
        // 4. จองพื้นที่: ใช้ข้อความที่ยาวที่สุด และจะถูกซ่อนด้วย .opacity(0)
        return "อีเมลนี้ยังไม่ได้ลงทะเบียน"
    }

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
                
                EmailInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.email,
                    isValid: $viewModel.isEmailValid,
                    displayErrorMessage: currentErrorMessage, // ส่งข้อความที่คำนวณแล้ว
                    isErrorActive: isAnyError // ส่งสถานะการแสดงผล
                                )
                .onChange(of: viewModel.email) {
                    viewModel.serverErrorMessage = nil
                    if !viewModel.email.isEmpty {
                        viewModel.isEmailValid = viewModel.isValidEmail(email: viewModel.email)
                    } else {
                        viewModel.isEmailValid = false
                    }
                }
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        viewModel.handleSendOTP { success in
                            if success {
                                navigateToOTP = true
                            }
                        }
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top)
                
                Spacer()
                
            }//ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $navigateToOTP) {
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
