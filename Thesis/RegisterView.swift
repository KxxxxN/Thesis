//
//  RegisterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var isPrivacyAccepted: Bool = false
    @State private var showPrivacyPopup: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack{ //เปิด Vstack1
                    ZStack {
                        Text("ลงทะเบียน")
                            .font(.noto(25, weight: .bold))
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.leading, 18)
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, 38)
                    
                    // MARK: Form Fields
//                    VStack(spacing: 26) {
//                        
//                        InputField(title: "ชื่อผู้ใช้", placeholder: "กรุณากรอกชื่อผู้ใช้", text: $firstName)
//                        
//                        InputField(title: "นามสกุล", placeholder: "กรุณากรอกนามสกุล", text: $lastName)
//                        
//                        InputField(title: "อีเมล", placeholder: "กรุณากรอกอีเมล", text: $email)
//                        
//                        InputField(title: "เบอร์โทร", placeholder: "กรุณากรอกเบอร์โทร", text: $phone)
//                        
//                        PasswordField(title: "รหัสผ่าน", placeholder: "กรอกรหัสผ่าน", text: $password)
//                        
//                        PasswordField(title: "ยืนยันรหัสผ่าน",
//                                      placeholder: "กรุณายืนยันรหัสผ่าน",
//                                      text: $confirmPassword)
//                    }
                    
                    VStack(spacing: 26){ //เปิด Vstack2
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ชื่อ")
                                .font(.noto(20, weight: .bold))
                            
                            TextField("กรุณากรอกชื่อ", text: $firstName)
                                .padding()
                                .frame(width: 345, height: 49)
                                .background(Color.textFieldColor)
                                .cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("นามสกุล")
                                .font(.noto(20, weight: .bold))
                            
                            TextField("กรุณากรอกนามสกุล", text: $lastName)
                                .padding()
                                .frame(width: 345, height: 49)
                                .background(Color.textFieldColor)
                                .cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("อีเมล")
                                .font(.noto(20, weight: .bold))
                            
                            TextField("กรุณากรอกอีเมล", text: $email)
                                .padding()
                                .frame(width: 345, height: 49)
                                .background(Color.textFieldColor)
                                .cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("เบอร์โทร")
                                .font(.noto(20, weight: .bold))
                            
                            TextField("กรุณากรอกเบอร์โทร", text: $phone)
                                .padding()
                                .frame(width: 345, height: 49)
                                .background(Color.textFieldColor)
                                .cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("รหัสผ่าน")
                                .font(.noto(20, weight: .bold))
                            
                            HStack { //เปิด Hstack1
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
                            } //ปิด Hstack1
                            .padding()
                            .frame(width: 345, height: 49)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("ยืนยันรหัสผ่าน")
                                .font(.noto(20, weight: .bold))
                            
                            HStack { //เปิด Hstack1
                                if isPasswordVisible {
                                    TextField("กรุณายืนยันรหัสผ่าน", text: $confirmPassword)
                                } else {
                                    SecureField("กรุณายืนยันรหัสผ่าน", text: $confirmPassword)
                                }
                                
                                Button {
                                    isConfirmPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.black)
                                }
                            } //ปิด Hstack1
                            .padding()
                            .frame(width: 345, height: 49)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)
                        }
                    }//ปิด Vstack2
                    
                    // MARK: Privacy Accept
                    HStack {
                        Button { isPrivacyAccepted.toggle() } label: {
                            Image(systemName: isPrivacyAccepted ? "checkmark.square.fill" : "square")
                                .foregroundColor(isPrivacyAccepted ? .mainColor : .gray)
                                .font(.system(size: 20))
                        }
                        HStack(spacing:0){
                            Text("ฉันได้อ่านและยอมรับ")
                                .font(.noto(15, weight: .medium))
                            
                            Button(action: {
                                showPrivacyPopup = true
                            }){
                                Text("นโยบายความเป็นส่วนตัว*") .font(.noto(15,weight: .semibold)) .foregroundColor(Color.dangerColor) .underline(color: .dangerColor)
                            }
                        }
                    }
                    .frame(width: 345, alignment: .leading)
                    .padding(.top, 15)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: showPrivacyPopup ? 6 : 0)
                
                // MARK: Privacy Popup
                if showPrivacyPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { showPrivacyPopup = false }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        }
                                        
                        ScrollView {
                            Text("""
                            ใส่เนื้อหานโยบายความเป็นส่วนตัวของคุณที่นี่...
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                            """)
                            .font(.noto(16))
                            .padding()
                        }
                        .frame(height: 500)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                    }
                    .padding()
                    .frame(width: 386)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .transition(.scale)
                    .animation(.spring(), value: showPrivacyPopup)
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
