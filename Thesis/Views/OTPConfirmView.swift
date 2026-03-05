//
//  OTPConfirmView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

enum OTPSource {
    case forgotPassword // ไป ChangePasswordView
    case changeEmail    // แสดง Popup สำเร็จ
    case confirmEmail   // ไป NewPasswordView
}

struct OTPConfirmView: View {
    let source: OTPSource
    let email: String
//    let refCode: String
    
    @StateObject private var viewModel = OTPConfirmViewModel()
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack{
//            NavigationStack {
                VStack {
                    // Header
                    ZStack {
                        Text("ยืนยันรหัส OTP")
                            .font(.noto(25, weight: .bold))
                        
                        HStack {
                            BackButton()                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, 65)
                    
                    Text("ใส่รหัสที่ส่งไปยังอีเมลของคุณ")
                        .font(.noto(20, weight: .semibold))
                        .padding(.bottom, 18)
                    
                    // Component ช่อง OTP
                    OTPInputView(viewModel: viewModel, focusedField: $focusedField)
                        .padding(.bottom, 15)
                    
                    // ส่วนแสดงผล Error
                    Text(viewModel.errorMessage)
                        .font(.noto(15, weight: .medium))
                        .foregroundColor(Color.errorColor)
                        .frame(height: 15)
                        .padding(.bottom,0)
                        .opacity(viewModel.shouldShowError ? 1 : 0)
                    
//                    HStack(spacing: 5){
//                        Text("รหัสอ้างอิง :")
//                            .font(.noto(15, weight: .medium))
//                            .foregroundColor(Color.placeholderColor)
//                        
////                        let refCode = "A9F4K2"
//                        Text(refCode)
//                            .font(.noto(15, weight: .medium))
//                            .foregroundColor(Color.placeholderColor)
//                        
//                    }
                    .padding(.bottom,18)
                    
                    PrimaryButton(
                        title: "ยืนยัน",
                        action: {
                            focusedField = nil
                            Task {
                                await viewModel.verifyOTP(source: source, email: email)
                            }
                        },
                        width: 155, // ความกว้างของปุ่ม
                        height: 49 // ความสูงของปุ่ม
                    )
                    
                    HStack(spacing: 8){
                        Text("ยังไม่ได้รับรหัส?")
                            .font(.noto(15,weight: .medium))
                            .foregroundColor(.black)
                        
                        if viewModel.resendCooldown > 0 {
                            Text("ส่งรหัสใหม่ (\(viewModel.resendCooldown))")
                                .font(.noto(15, weight: .bold))
                                .foregroundColor(.placeholderColor)  // สีจางลงตอน cooldown
                        } else {
                            Button(action: {
                                Task {
                                    await viewModel.resendOTP(source: source, email: email)
                                }
                            }) {
                                Text("ส่งรหัสใหม่")
                                    .font(.noto(15, weight: .bold))
                                    .foregroundColor(.mainColor)
                                    .underline(color: .mainColor)
                            }
                        }
                    }
                    .padding(.top,15)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    focusedField = 0
                    viewModel.startCooldown()
                }
                
                // ผูกสถานะการนำทางจาก ViewModel กับ AppStorage/Navigation
                // MARK: - 3 เส้นทาง Navigation
                .navigationDestination(isPresented: $viewModel.navigateToChangePW) {
                    ChangePasswordView()
                }
                .navigationDestination(isPresented: $viewModel.navigateToNewPW) {
                    NewPasswordView()
                }
                .navigationDestination(isPresented: $viewModel.emailChangeSuccess) {
                    ProfileView()
                }
                
//            }
            .navigationBarBackButtonHidden(true)
            
            // MARK: Success Popup
            if viewModel.showSuccessPopup {
                SuccessPopupView(message: "แก้ไขอีเมลสำเร็จ") {
                    viewModel.showSuccessPopup = false
                    viewModel.emailChangeSuccess = true
                }
            }
            
             // MARK: Error Popup
            if viewModel.showErrorPopup && source == .changeEmail {
                ErrorPopupView(title: "แก้ไขอีเมลไม่สำเร็จ"){
                    withAnimation {
                        viewModel.showErrorPopup = false
                        viewModel.resetOTPFields() // ล้างข้อมูลเพื่อให้พิมพ์ใหม่ได้ง่าย
                        focusedField = 0
                    }
                }
            }
        }
    }
}

#Preview {
    OTPConfirmView(source: .changeEmail, email: "1123kansinee@gmail.com")
}
