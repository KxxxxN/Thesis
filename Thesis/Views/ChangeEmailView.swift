//
//  ChangeEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct ChangeEmailView: View {
    @StateObject private var viewModel = ChangeEmailViewModel()
    @Environment(\.dismiss) private var dismiss
//    @State private var navigateToProfile: Bool = false
    
    var body: some View {
//        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("ยืนยันแก้ไขอีเมล")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    HStack {
                        BackButton(
//                            action: {
//                                navigateToProfile = true
//                            }
                        )
                        
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
                        Task {
                            await viewModel.validateEmail()
                        }
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
                OTPConfirmView(
                    source: .changeEmail,
                    email: viewModel.newEmail
                )
            }
//            .navigationDestination(isPresented: $navigateToProfile) {
//                ProfileView()
//            }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChangeEmailView()
}
