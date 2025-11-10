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
    
    @State private var showRegister = false
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center) { //เปิด Vstack1
                
                Spacer()
                
                Text("LOGO")
                    .font(.system(size: 24))
                
                VStack(spacing: 26){//เปิด Vstack2
                    
                    VStack(alignment: .leading, spacing: 5) { //เปิด Vstack3
                        Text("ชื่อผู้ใช้")
                            .font(.noto(20, weight: .bold))
                        
                        TextField("กรุณากรอกชื่อผู้ใช้", text: $username)
                            .padding()
                            .frame(width: 345, height: 49)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)
                    }//ปิด Vstack3
                    .padding(.top, 50)
                    
                    VStack(alignment: .leading, spacing: 5) { //เปิด Vstack4
                        Text("รหัสผ่าน")
                            .font(.noto(20, weight: .bold))
                        
                        HStack {//เปิด Hstack1
                            if isPasswordVisible {
                                TextField("กรุณากรอกรหัสผ่าน", text: $password)
                            } else {
                                SecureField("กรุณากรอกรหัสผ่าน", text: $password)
                            }
                            
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.black)
                            }
                        }//ปิด Hstack1
                        .padding()
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        
                        Button(action: {
                                // forgot password action
                        }) {
                            Text("ลืมรหัสผ่าน?")
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.mainColor)
                        }
                        .frame(width: 345, alignment: .trailing)
                    }//ปิด Vstack4
                }//ปิด Vstack2
                
                Button(action: {
                    //                    print("Login tapped")
                    isLoggedIn = true
                }) {
                    Text("เข้าสู่ระบบ")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 155, height: 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                }
                .padding(.top, 21)

                HStack(spacing: 8){
                    Text("ยังไม่มีบัญชี?")
                        .font(.noto(15,weight: .medium))
                        .foregroundColor(.black)
                        
                    Button(action: {
//                        print("Register")
                        showRegister = true
                    }){
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
                    Button(action: {
                        print("Google")
                    }){HStack(spacing: 15) {
                        Image("GoogleIcon")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("ดำเนินการต่อด้วย Google")
                            .font(.noto(18, weight: .medium))
                            .foregroundColor(.mainColor)
                    }
                    .padding(.leading, 54)
                    .frame(width: 345, height: 49, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainColor, lineWidth: 2)
                    )
                    }
                    .padding(.top, 21)
                    
                    Button(action: {
                        print("X")
                    }){HStack(spacing: 15) {
                        Image("XIcon")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("ดำเนินการต่อด้วย X (Twitter)")
                            .font(.noto(18, weight: .medium))
                            .foregroundColor(.mainColor)
                    }
                    .padding(.leading, 54)
                    .frame(width: 345, height: 49, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainColor, lineWidth: 2)
                    )
                    }
                }
                
                Spacer()
                
            } //ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}


#Preview {
    LoginView()
}
