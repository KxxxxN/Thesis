//
//  ChangePasswordField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

struct ChangePasswordField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "กรุณากรอกรหัสผ่าน"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Title(title: title)
            
            HStack{
                ZStack(alignment: .leading){
                    PlaceholderView(text: text, placeholder: placeholder)
                    
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("",text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    } else {
                        TextField("", text: $text)
                    }
                }
                
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle()} label: {
                        Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            .modifier(ValidationBorder(isValid: isValid))
            
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .opacity(isValid ? 0 : 1)
            }
            .frame(height: 20, alignment: .top)
            .clipped()
            .padding(.leading, 7)
            .padding(.top, 4)
        }
    }
}
