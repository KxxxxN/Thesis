//
//  PopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//

import SwiftUI

// MARK: - Privacy Popup View
struct PrivacyPopupView: View {
    @Binding var showPrivacyPopup: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
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
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit.  
                    ... (ข้อความนโยบายความเป็นส่วนตัว)
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
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale)
            .animation(.spring(), value: showPrivacyPopup)
        }
    }
}

// MARK: - Success Popup View
struct SuccessPopupView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack {
                VStack(spacing: 29) {
                    Image("Passmark") // ต้องมั่นใจว่า asset นี้มีอยู่ในโครงการ
                        .resizable()
                        .frame(width: 111, height: 111)
                    
                    Text("สร้างบัญชีสำเร็จ")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(40)
                .frame(width: 343, height: 255)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.scale)
            }
            .padding()
        }
    }
}

// MARK: - Preview
// สามารถรวม Preview ไว้ในไฟล์เดียวได้
#Preview("Privacy Popup") {
    PrivacyPopupView(showPrivacyPopup: .constant(true))
}

#Preview("Success Popup") {
    SuccessPopupView()
}
