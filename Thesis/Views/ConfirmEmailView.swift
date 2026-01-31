//
//  ConfirmEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 12/12/2568 BE.
//

import SwiftUI

struct ConfirmEmailView: View {
    @StateObject private var viewModel = ConfirmEmailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text("ยืนยันแก้ไขรหัสผ่าน")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.bottom, 30)
                

                // MARK: - Email Input Field
                // ใช้ LoginInputField เพื่อให้มีพื้นที่จอง Error 20px ตามมาตรฐานแอปคุณ
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.email,
                    isValid: .constant(!viewModel.isSubmitted || viewModel.emailError == nil),
                    errorMessage: viewModel.isSubmitted ? (viewModel.emailError ?? "") : ""
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.email) { _, _ in
                    viewModel.clearError()
                }
                
                // MARK: - Action Button
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        viewModel.verifyEmailBeforeChange()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PopToProfile"))) { _ in
                dismiss()
            }
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                OTPConfirmView(
                    source: .confirmEmail,
                    email: viewModel.email,
                    refCode: viewModel.refCodeGenerated
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ConfirmEmailView()
}
