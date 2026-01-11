//
//  ChangeEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct ChangeEmailView: View {
    @StateObject private var viewModel = ChangeEmailViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("ยืนยันแก้ไขอีเมล")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    HStack {
                            BackButton()
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 30)
                
                // MARK: - Input Field
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมลที่ต้องการแก้ไข",
                    text: $viewModel.newEmail,
                    isValid: .constant(!viewModel.isSubmitted || viewModel.emailError == nil),
                    errorMessage: viewModel.isSubmitted ? (viewModel.emailError ?? "") : ""
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.newEmail) { _, _ in
                    viewModel.clearError()
                }
                
                // MARK: - Action Button
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        viewModel.validateEmail()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                OTPConfirmView(source: .changeEmail)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChangeEmailView()
}
