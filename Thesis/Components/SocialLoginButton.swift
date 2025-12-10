//
//  SocialLoginButton.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: SocialLoginButton
struct SocialLoginButton: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .font(.noto(18, weight: .medium)) // ใช้ Font ที่คุณกำหนด
                    .foregroundColor(.mainColor)
            }
            .padding(.leading, 54) // จัดตำแหน่งให้เป็นไปตาม Layout เดิม
            .frame(width: 345, height: 49, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainColor, lineWidth: 2)
            )
        }
    }
}
