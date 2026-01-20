//
//  confirmPasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ConfirmPasswordView: View {
    @StateObject private var viewModel = ConfirmPasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text("ยืนยันรหัสผ่าน")
                        .font(.noto(25, weight: .bold))
                        
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.bottom, 30)

                // MARK: - Input Field
                LoginInputField(
                    title: "รหัสผ่าน",
                    placeholder: "กรอกรหัสผ่าน",
                    text: $viewModel.password,
                    isValid: .constant(!viewModel.isSubmitted || viewModel.passwordError == nil),
                    errorMessage: viewModel.isSubmitted ? (viewModel.passwordError ?? "") : "",
                    isSecure: true,
                    isPasswordToggle: $viewModel.isPasswordVisible
                )
                .onChange(of: viewModel.password) { _, _ in
                    viewModel.clearError()
                }
                
                // MARK: - Confirm Button
                PrimaryButton(
                    title: "ยืนยัน",
                    action: {
                        viewModel.verifyPassword()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $viewModel.navigateToNextStep) {
                ChangeEmailView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ConfirmPasswordView()
}
