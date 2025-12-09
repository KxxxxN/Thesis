//
//  SwiftUIView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center) { //เปิด Vstack1
                
                Spacer()
                
                Text("LOGO")
                    .font(.system(size: 24))
                    .padding(.bottom, 50)
                            
                VStack(spacing: 0) {
                    LoginInputField(
                        title: "อีเมล",
                        placeholder: "กรอกอีเมล",
                        text: $viewModel.email,
                        isValid: .constant(viewModel.emailError == nil),
                        errorMessage: viewModel.emailError ?? ""
                    )
                    .onChange(of: viewModel.email) {
                        let currentEmail = viewModel.email.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // 1. ตรวจสอบว่าช่องไม่ว่างเปล่า
                        if !currentEmail.isEmpty {
                            viewModel.emailError = nil
                            
                        } else {
                            viewModel.emailError = "กรุณากรอกอีเมล"
                        }
                    }
                    
                    // 2. ช่องป้อนรหัสผ่าน
                    LoginInputField(
                        title: "รหัสผ่าน",
                        placeholder: "กรอกรหัสผ่าน",
                        text: $viewModel.password,
                        isValid: .constant(viewModel.passwordError == nil),
                        errorMessage: viewModel.passwordError ?? "",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isPasswordVisible
                    )
                    .onChange(of: viewModel.password) {
                        let currentPassword = viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if !currentPassword.isEmpty {
                            viewModel.passwordError = nil
                            
                        } else {
                            viewModel.passwordError = "กรุณากรอกรหัสผ่าน"
                        }
                    }
                    .padding(.bottom, -15)
                    
                        
                    // 3. ปุ่มลืมรหัสผ่าน (NavigationLink)
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: EmailForgotPassword()){
                            Text("ลืมรหัสผ่าน?")
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.mainColor)
                        }
                    }
                    .frame(width: 345)
                }
                
                PrimaryButton(
                    title: "เข้าสู่ระบบ",
                    action:{
                        viewModel.login()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 21)

                HStack(spacing: 8){
                    Text("ยังไม่มีบัญชี?")
                        .font(.noto(15,weight: .medium))
                        .foregroundColor(.black)
                        
                    NavigationLink(destination: RegisterView()){
                        Text("ลงทะเบียน")
                            .font(.noto(15,weight: .bold))
                            .foregroundColor(.mainColor)
                            .underline(color: .mainColor)
                    }
                }
                .padding(.top,10)
                
                HStack(spacing: 6){
                    Divider()
                        .frame(width: 108,height: 2)
                        .background(Color.textFieldColor)
                    
                    Text("หรือลงชื่อเข้าใช้ด้วย")
                        .font(.noto(15,weight: .medium))
                        .foregroundColor(Color.black)
                    
                    Divider()
                        .frame(width: 108,height: 2)
                        .background(Color.textFieldColor)
                }
                .padding(.top, 64.5)
                
                VStack(spacing: 16){
                    SocialLoginButton(iconName: "GoogleIcon", title: "ดำเนินการต่อด้วย Google") {
                        print("Google Login Action")
                    }
                    .padding(.top, 21)
                    
                    SocialLoginButton(iconName: "XIcon", title: "ดำเนินการต่อด้วย X (Twitter)") {
                        print("X Login Action")
                    }
                }
                Spacer()
                
            } //ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}


#Preview {
    LoginView()
}
