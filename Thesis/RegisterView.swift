//
//  RegisterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    // ใช้ @StateObject เพื่อจัดการ ViewModel ที่เก็บ State และ Logic
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{ //เปิด Vstack1
                    // Header (ย้าย logic ออกไปไม่ได้)
                    ZStack {
                        Text("ลงทะเบียน")
                            .font(.noto(25, weight: .bold))
                            
                        HStack {
                            Button {
                                //                                viewModel.showSuccessPopup = false;
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.leading, 25)
    
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                        
                    // MARK: Form Fields
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{ //เปิด Vstack2
                                
                            // First Name
                            InputField(
                                title: "ชื่อ",
                                placeholder: "กรอกชื่อภาษาไทย",
                                text: $viewModel.firstName,
                                isValid: $viewModel.isFirstNameValid,
                                errorMessage: viewModel.firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง",
                                
                            )
                            // ใช้ onChange รูปแบบใหม่
                            .onChange(of: viewModel.firstName) {
                                if !viewModel.firstName.isEmpty {
                                    viewModel.isFirstNameValid = viewModel.isNameValid(name: viewModel.firstName)
                                }
                            }
                                
                            // Last Name
                            InputField(
                                title: "นามสกุล",
                                placeholder: "กรอกนามสกุลภาษาไทย",
                                text: $viewModel.lastName,
                                isValid: $viewModel.isLastNameValid,
                                // ปรับ errorMessage ให้เข้ากับ ViewModel
                                errorMessage: viewModel.lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง",
                            )
                            .onChange(of: viewModel.lastName) {
                                if !viewModel.lastName.isEmpty {
                                    viewModel.isLastNameValid = viewModel.isNameValid(name: viewModel.lastName)
                                }
                            }
                                
                            // Email
                            InputField(
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
                                    viewModel.isEmailValid = viewModel.isValidEmail(email: viewModel.email)
                                }
                            }
                                
                            // Phone
                            InputField(
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
                                    viewModel.isPhoneValid = viewModel.isValidPhone(phone: viewModel.phone)
                                }
                            }
                                
                            // Password
                            InputField(
                                title: "รหัสผ่าน",
                                placeholder: "อย่างน้อย 8 ตัวอักษร",
                                text: $viewModel.password,
                                isValid: $viewModel.isPasswordValid,
                                errorMessage: viewModel.password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isPasswordVisible
                            )
                            .onChange(of: viewModel.password) {
                                
                                let password = viewModel.password
                                
                                let confirmPassword = viewModel.confirmPassword
                                
                                if !password.isEmpty {
                                    
                                    let regexPassed = viewModel.isPasswordValid(password: password)
                                    let matchConfirmed = (password == confirmPassword)
                                    
                                    // **1. แก้ไข Logic รวม:** // isPasswordValid = (Regex ผ่าน) AND (ช่อง Confirm ว่าง หรือ ตรงกัน)
                                    viewModel.isPasswordValid = regexPassed && (confirmPassword.isEmpty || matchConfirmed)
                                    
                                    // **2. อัปเดตสถานะของ Confirm Password ด้วย**

                                    if !confirmPassword.isEmpty {

                                        viewModel.isConfirmPasswordValid = matchConfirmed
                                        
                                    }
                                } else {
                                        // **3. จัดการช่องว่าง:** ถ้าว่าง ให้ถือว่า Valid ชั่วคราว
                                        viewModel.isPasswordValid = true
                                        
                                    }
                                
                            }
                                
                            // Password Validation Checklist
                            if !viewModel.isPasswordValid(password: viewModel.password) {
                                PasswordValidationChecklist(viewModel: viewModel)
                                    .padding(.top, -7)
                                    .padding(.bottom, 5)
                            }
                                
                            // Confirm Password
                            InputField(
                                title: "ยืนยันรหัสผ่าน",
                                placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                text: $viewModel.confirmPassword,
                                isValid: $viewModel.isConfirmPasswordValid,
                                errorMessage: viewModel.confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isConfirmPasswordVisible
                            )
                            .onChange(of: viewModel.confirmPassword) {
                                // Live validation:
                                if !viewModel.confirmPassword.isEmpty {
                                    // isConfirmPasswordValid จะเป็น false ถ้าไม่ตรงกัน
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
                                            .foregroundColor(Color.dangerColor)
                                            .underline(color: .dangerColor)
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: 345, alignment: .leading)
                                
                            if !viewModel.isPrivacyAccepted && viewModel.isFormSubmitted {
                                Text("จำเป็นต้องยอมรับนโยบายความเป็นส่วนตัว")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(Color.errorColor)
                                    .frame(width: 345, alignment: .leading)
                            }
                        }
                        .padding(.top,16)
                            
                        Button(action: {
                            // ย้าย logic ไปที่ ViewModel และใช้ผลลัพธ์ในการแสดง Popup
                            viewModel.isFormSubmitted = true
                            if viewModel.validateForm() {
                                print("สร้างบัญชีสำเร็จ")
                                viewModel.showSuccessPopup = true
                                
                                Task {
                                    try await Task.sleep(nanoseconds: 2_000_000_000)
                                        
                                    // ตรวจสอบว่า Popup ยังเปิดอยู่หรือไม่ก่อนทำการปิด
                                    if viewModel.showSuccessPopup {
                                        viewModel.showSuccessPopup = false
                                        dismiss()
                                    }
                                }
                            } else {
                                print("มีช่องที่ต้องกรอก")
                            }
                        }) {
                            Text("สร้างบัญชี")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 155, height: 49)
                                .background(Color.mainColor)
                                .cornerRadius(20)
                        }
                        .padding(.top, 13)
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: viewModel.showPrivacyPopup || viewModel.showSuccessPopup ? 6 : 0)
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
