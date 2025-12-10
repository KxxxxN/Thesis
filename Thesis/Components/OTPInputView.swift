//
//  OTPInputView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: - Otp Input
struct OTPInputView: View {
    @ObservedObject var viewModel: OTPConfirmViewModel
    
    @FocusState.Binding var focusedField: Int?
    
    private func borderColor(for index: Int) -> Color {
        if viewModel.isFieldInvalid[index] {
            return Color.errorColor
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $viewModel.otpFields[index])
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60, height: 75)
                    .background(Color.textFieldColor)
                    .cornerRadius(20)
                    .font(.noto(30, weight: .medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            // ใช้สถานะ isFieldInvalid จาก ViewModel
                            .stroke(borderColor(for: index), lineWidth: 2)
                    )
                    // ผูก focus state กับ index
                    .focused($focusedField, equals: index)
                    // ใช้ .onChange เพื่อจัดการ Logic ผ่าน ViewModel
                    .onChange(of: viewModel.otpFields[index]) { oldValue, newValue in
                        // เรียกใช้ฟังก์ชันใน ViewModel และส่ง focusedField เข้าไป
                        viewModel.handleOTPChange(index: index, newValue: newValue, focusedField: &focusedField)
                    }
            }
        }
    }
}
