//
//  SwiftUIView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isPasswordVisible: Bool = false
        
    @State private var isEmailError: Bool = false
    @State private var isPasswordError: Bool = false
    @State private var loginErrorMessage: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    func validateAndLogin() {
        loginErrorMessage = ""
        
        isEmailError = username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        isPasswordError = password.isEmpty
        
        if !isEmailError && !isPasswordError {

            let validUsername = "user@example.com"
            let validPassword = "12345678"
            
            if username == validUsername && password == validPassword {
                // Login สำเร็จ
                isLoggedIn = true
                print("Login Successful")
                // ล้างสถานะข้อผิดพลาดทั้งหมดเมื่อสำเร็จ
                isEmailError = false
                isPasswordError = false
            } else {
                // Login ล้มเหลว - แสดงข้อความอีเมลหรือรหัสผ่านไม่ถูกต้อง
                loginErrorMessage = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                print("Login Failed: Incorrect credentials")
                
                // **ส่วนที่เพิ่ม/แก้ไข:**
                // ตั้งค่า isEmailError และ isPasswordError เป็น true เพื่อให้กรอบสีแดงขึ้นพร้อมกัน
                isEmailError = true
                isPasswordError = true
            }
            
        } else {
            print("Validation Failed: Empty fields")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center) { //เปิด Vstack1
                
                Spacer()
                
                Text("LOGO")
                    .font(.system(size: 24))
                                        
                    VStack(alignment: .leading, spacing: 5) { //เปิด Vstack3
                        Text("อีเมล")
                            .font(.noto(20, weight: .bold))
                        
                        ZStack(alignment: .leading) {
                            if username.isEmpty {
                                Text("กรอกอีเมล")
                                    .foregroundColor(Color.placeholderColor)
                            }
                            
                            TextField("", text: $username)
                        }
                        .padding()
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isEmailError || !loginErrorMessage.isEmpty ? Color.errorColor : Color.clear, lineWidth: 2)
                        )
                        
                        if !loginErrorMessage.isEmpty {
                            Text(loginErrorMessage) // แสดง "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.errorColor)
                                .padding(.leading,7)
                        } else {
                            Text("กรุณากรอกอีเมล")
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.errorColor)
    
                                .opacity(isEmailError ? 1 : 0)
                                .padding(.leading,7)
                        }
                        
                    }//ปิด Vstack3
                    .padding(.top, 50)
                    
                    VStack(alignment: .leading, spacing: 5) { //เปิด Vstack4
                        Text("รหัสผ่าน")
                            .font(.noto(20, weight: .bold))
                        
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("กรอกรหัสผ่าน")
                                    .foregroundColor(Color.placeholderColor)
                            }
                            
                            HStack {//เปิด Hstack1
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                } else {
                                    SecureField("", text: $password)
                                }
                                
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.black)
                                }
                            }
                        }//ปิด Hstack1
                        .padding()
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isPasswordError || !loginErrorMessage.isEmpty ? Color.errorColor : Color.clear, lineWidth: 2)
                        )
                        HStack{
                            if !loginErrorMessage.isEmpty {
                                Text(loginErrorMessage)
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(.errorColor)
                                    .padding(.leading,7)
                            } else {
                                Text("กรุณากรอกรหัสผ่าน")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(.errorColor)
                                    .opacity(isPasswordError ? 1 : 0)
                                    .padding(.leading,7)
                            }
                            Spacer()
                            
                            Button(action: {
                                // forgot password action
//                                NavigationLink(destination: EmailForgotPassword())
                            }) {
                                Text("ลืมรหัสผ่าน?")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(.mainColor)
                            }
                        }
                        .frame(width: 345)
                    }//ปิด Vstack4
                
                PrimaryButton(
                    title: "เข้าสู่ระบบ",
                    action: validateAndLogin,
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
    }
}


#Preview {
    LoginView()
}
