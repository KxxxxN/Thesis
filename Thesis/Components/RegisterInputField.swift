//
//  RegisterInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

// MARK: - Input Field Component
struct RegisterInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "จำเป็นต้องระบุ"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RequiredTitle(title: title)
                 
            HStack {
                ZStack(alignment: .leading) {
                    PlaceholderView(text: text, placeholder: placeholder)
                    
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    } else {
                        TextField("", text: $text)
                    }
                }
                
                
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle() } label: {
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
                 
            // ข้อความแสดงข้อผิดพลาด
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .frame(height: 20)
                    .padding(.top,3)
                    .opacity(isValid ? 0 : 1)
            }
            .clipped()
        }
    }
}
