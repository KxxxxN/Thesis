//
//  ChangePasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("เปลี่ยนรหัสผ่านใหม่")
                        .font(.noto(25, weight: .bold))
                    HStack { //เปิด Hstack1
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.leading, 18)
                        
                        Spacer()
                    }//ปิด Hstack1
                }//ปิด Zstack1
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 0) {
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
                
                VStack(alignment: .leading, spacing: 0) {
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
                .padding(.top, 26)
                
//                Button(action: {
//                    showPrivacyPopup = true
//                }){
                NavigationLink(destination: LoginView()) {
                    Text("ยืนยัน")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 155, height: 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                }
                .padding(.top, 55)
                
                Spacer()
                
            }//ปิด Vstack1
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }

}

#Preview {
    ChangePasswordView()
}
