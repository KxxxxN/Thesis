//
//  EmailForgotPassword.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

struct EmailForgotPassword: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            VStack{ //เปิด Vstack1
                ZStack { //เปิด Zstack1
                    Text("ลืมรหัสผ่าน")
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
                
                VStack(alignment: .leading, spacing: 0) { //เปิด Vstack2
                    Text("อีเมล")
                        .font(.noto(20, weight: .bold))
                    
                    TextField("กรุณากรอกอีเมล", text: $email)
                        .padding()
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                } //ปิด Vstack2
                
//                Button(action: {
//                    showPrivacyPopup = true
//                }){
                NavigationLink(destination: OTPConfirmView()) {
                    Text("ส่งรหัส OTP")
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
    EmailForgotPassword()
}
