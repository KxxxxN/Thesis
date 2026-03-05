//
//  ConfirmEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 12/12/2568 BE.
//

import SwiftUI

@MainActor
struct ConfirmEmailView: View {
    let currentEmail: String
    @StateObject private var viewModel = ConfirmEmailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                ReadOnlyEmailField(title: "ที่อยู่อีเมล", email: viewModel.email)
                
                Text("เพื่อความปลอดภัย ไม่สามารถเปลี่ยนอีเมลได้ในหน้านี้")
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(.placeholderColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                
                // MARK: - Action Button
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        Task {
                            await viewModel.verifyEmailBeforeChange()
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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PopToProfile"))) { _ in
                dismiss()
            }
            .onAppear {
                viewModel.email = currentEmail
            }
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                OTPConfirmView(
                    source: .confirmEmail,
                    email: viewModel.email
                )
            }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ConfirmEmailView(currentEmail: "kansinee.klinkhachon@g.swu.ac.th")
}
