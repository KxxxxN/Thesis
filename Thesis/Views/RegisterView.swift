//
//  RegisterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{ //เปิด Vstack1
                    ZStack {
                        Text("ลงทะเบียน")
                            .font(.noto(25, weight: .bold))
                            
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                        
                    // MARK: Form Fields
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: -3){ //เปิด Vstack2
                            
                            // First Name
                            RegisterInputField(
                                title: "ชื่อ",
                                placeholder: "กรอกชื่อภาษาไทย",
                                text: $viewModel.firstName,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isFirstNameValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isFirstNameValid ? (viewModel.firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง") : ""
                            )
                            .onChange(of: viewModel.firstName) { _, _ in
                                viewModel.clearError(for: "firstName")
                            }
                            
                            // Last Name
                            RegisterInputField(
                                title: "นามสกุล",
                                placeholder: "กรอกนามสกุลภาษาไทย",
                                text: $viewModel.lastName,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isLastNameValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isLastNameValid ? (viewModel.lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง") : ""
                            )
                            .onChange(of: viewModel.lastName) { _, _ in
                                viewModel.clearError(for: "lastName")
                            }
                            
                            // Email
                            RegisterInputField(
                                title: "อีเมล",
                                placeholder: "กรอกอีเมล",
                                text: $viewModel.email,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isEmailValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isEmailValid ? (viewModel.email.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบอีเมลไม่ถูกต้อง") : ""
                            )
                            .onChange(of: viewModel.email) { _, _ in
                                viewModel.clearError(for: "email")
                            }

                            
                            // Phone
                            RegisterInputField(
                                title: "เบอร์โทร",
                                placeholder: "0XX-XXX-XXXX",
                                text: $viewModel.phone,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPhoneValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPhoneValid ? (viewModel.phone.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบเบอร์โทรไม่ถูกต้อง") : ""
                            )
                            .onChange(of: viewModel.phone) { _, _ in
                                viewModel.clearError(for: "phone")
                            }
                            
                            // Password
                            RegisterInputField(
                                title: "รหัสผ่าน",
                                placeholder: "อย่างน้อย 8 ตัวอักษร",
                                text: $viewModel.password,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPasswordValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPasswordValid ? (viewModel.password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง") : "",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isPasswordVisible
                            )
                            .onChange(of: viewModel.password) { _, _ in
                                viewModel.clearError(for: "password")
                                // ตรวจสอบ Confirm Password ใหม่ด้วยถ้ามีข้อมูลอยู่แล้ว
                                if !viewModel.confirmPassword.isEmpty {
                                    viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                                }
                            }
                            
                            // Password Validation Checklist
                            if !ValidationHelper.isPasswordValid(viewModel.password) {
                                PasswordValidationCheckView(password: viewModel.password)
                                    .padding(.top, 0)
                                    .padding(.bottom, 5)
                            }
                            
                            // Confirm Password
                            RegisterInputField(
                                title: "ยืนยันรหัสผ่าน",
                                placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                text: $viewModel.confirmPassword,
                                isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isConfirmPasswordValid),
                                errorMessage: viewModel.isRegisterSubmitted && !viewModel.isConfirmPasswordValid ? (viewModel.confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน") : "",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isConfirmPasswordVisible
                            )
                            .onChange(of: viewModel.confirmPassword) { _, _ in
                                viewModel.clearError(for: "confirmPassword")
                            }
                            
                        }//ปิด Vstack2
                        .padding(.horizontal, 40)
                            
                        // MARK: Privacy Accept
                        VStack {
                            HStack {
                                Button { viewModel.isPrivacyAccepted.toggle() } label: {
                                    Image(systemName: viewModel.isPrivacyAccepted ? "checkmark.square.fill" : "square")
                                        .foregroundColor(viewModel.isPrivacyAccepted ? .mainColor : .mainColor)
                                        .font(.system(size: 20))
                                }
                                HStack(spacing:0){
                                    Text("ฉันได้อ่านและยอมรับ")
                                        .font(.noto(15, weight: .medium))
                                        
                                    Button(action: { viewModel.showPrivacyPopup = true }){
                                        Text("นโยบายความเป็นส่วนตัว*")
                                            .font(.noto(15,weight: .semibold))
                                            .foregroundColor(Color.errorColor)
                                            .underline(color: .errorColor)
                                    }
                                }
                            }
                            .frame(width: 345, alignment: .leading)
                                
                            VStack(alignment: .leading, spacing: 0) {
                                Text("จำเป็นต้องยอมรับนโยบายความเป็นส่วนตัว")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(Color.errorColor)
                                    .opacity((!viewModel.isPrivacyAccepted && viewModel.isRegisterSubmitted) ? 1 : 0)
                                    .frame(width: 345, alignment: .leading)
                            }
                        }
                
                        PrimaryButton(
                            title: "สร้างบัญชี",
                            action: {
                                viewModel.register()
                            },
                            width: 155,
                            height: 49
                        )
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                // MARK: Privacy Popup
                if viewModel.showPrivacyPopup {
                    PrivacyPopupView(showPrivacyPopup: $viewModel.showPrivacyPopup)
                }
                
                // MARK: Success Popup
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: "สร้างบัญชีสำเร็จ") {
                        // action เมื่อกดปิด popup เอง (ถ้ามีปุ่มหรือการเคาะพื้นหลัง)
                        withAnimation {
                            viewModel.showSuccessPopup = false
                            dismiss()
                        }
                    }
                }
                
                // MARK: Error Popup
                if viewModel.showErrorPopup{
                    ErrorPopupView(title: "สร้างบัญชีไม่สำเร็จ"){
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}

#Preview {
    RegisterView()
}
