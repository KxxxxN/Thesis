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
                                isValid: $viewModel.isFirstNameValid,
                                errorMessage: viewModel.firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง",
                                
                            )
                            // ใช้ onChange รูปแบบใหม่
                            .onChange(of: viewModel.firstName) {
                                if !viewModel.firstName.isEmpty {
                                    viewModel.isFirstNameValid = ValidationHelper.isNameValid(name: viewModel.firstName)
                                }
                            }
                            
                            // Last Name
                            RegisterInputField(
                                title: "นามสกุล",
                                placeholder: "กรอกนามสกุลภาษาไทย",
                                text: $viewModel.lastName,
                                isValid: $viewModel.isLastNameValid,
                                // ปรับ errorMessage ให้เข้ากับ ViewModel
                                errorMessage: viewModel.lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง",
                            )
                            .onChange(of: viewModel.lastName) {
                                if !viewModel.lastName.isEmpty {
                                    viewModel.isLastNameValid = ValidationHelper.isNameValid(name: viewModel.lastName)
                                }
                            }
                            
                            // Email
                            RegisterInputField(
                                title: "อีเมล",
                                placeholder: "กรอกอีเมล",
                                text: $viewModel.email,
                                isValid: $viewModel.isEmailValid,
                                // ปรับ errorMessage ให้เข้ากับ ViewModel
                                errorMessage: viewModel.email.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบอีเมลไม่ถูกต้อง",
                            )
                            .onChange(of: viewModel.email) {
                                // Live validation
                                if !viewModel.email.isEmpty {
                                    viewModel.isEmailValid = ValidationHelper.isValidEmail(viewModel.email)
                                }
                            }
                            
                            // Phone
                            RegisterInputField(
                                title: "เบอร์โทร",
                                placeholder: "0XX-XXX-XXXX",
                                text: $viewModel.phone,
                                isValid: $viewModel.isPhoneValid,
                                // ปรับ errorMessage ให้เข้ากับ ViewModel
                                errorMessage: viewModel.phone.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบเบอร์โทรไม่ถูกต้อง",
                            )
                            .onChange(of: viewModel.phone) {
                                // Live validation
                                if !viewModel.phone.isEmpty {
                                    viewModel.isPhoneValid = ValidationHelper.isValidPhone(viewModel.phone)
                                }
                            }
                            
                            // Password
                            RegisterInputField(
                                title: "รหัสผ่าน",
                                placeholder: "อย่างน้อย 8 ตัวอักษร",
                                text: $viewModel.password,
                                isValid: $viewModel.isPasswordValid,
                                errorMessage: viewModel.password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isPasswordVisible
                            )
                            .onChange(of: viewModel.password) {
                                if !viewModel.password.isEmpty {
                                    viewModel.isPasswordValid = ValidationHelper.isPasswordValid(viewModel.password)
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
                                isValid: $viewModel.isConfirmPasswordValid,
                                errorMessage: viewModel.confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isConfirmPasswordVisible
                            )
                            // ตรวจสอบเมื่อมีการเปลี่ยนแปลงในช่องยืนยันรหัสผ่าน
                            .onChange(of: viewModel.confirmPassword) {
                                if !viewModel.confirmPassword.isEmpty {
                                    viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                                } else {
                                    viewModel.isConfirmPasswordValid = false
                                }
                            }
                            // 💡 สิ่งที่ต้องเพิ่ม: ตรวจสอบเมื่อมีการเปลี่ยนแปลงในช่องรหัสผ่าน (Password)
                            .onChange(of: viewModel.password) {
                                // บังคับให้ตรวจสอบความถูกต้องใหม่ หากช่องยืนยันรหัสผ่านถูกกรอกแล้ว
                                if !viewModel.confirmPassword.isEmpty {
                                    viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                                }
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
                                viewModel.isRegisterSubmitted = true
                                if viewModel.validateFormRegister() {
                                    print("สร้างบัญชีสำเร็จ")
                                    viewModel.showSuccessPopup = true

                                    Task {
                                        try await Task.sleep(nanoseconds: 2_000_000_000)

                                        if viewModel.showSuccessPopup {
                                            viewModel.showSuccessPopup = false
                                            dismiss()
                                        }
                                    }
                                } else {
                                    print("มีช่องที่ต้องกรอก")
                                }
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
                    SuccessPopupView()
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
