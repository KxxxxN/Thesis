//
//  OTPConfirmView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

struct OTPConfirmView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?

    var body: some View {
        NavigationStack {
            VStack {
                // Header
                ZStack {
                    Text("ยืนยันรหัส OTP")
                        .font(.noto(25, weight: .bold))

                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.leading, 18)
                        Spacer()
                    }
                }
                .padding(.bottom, 70)

                Text("ใส่รหัสที่ส่งไปยังอีเมลของคุณ")
                    .font(.noto(20, weight: .semibold))
                    .padding(.bottom, 18)

                // OTP 6 ช่อง
                HStack(spacing: 7) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otpFields[index])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 60, height: 75)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)
                            .font(.noto(30, weight: .medium))
                            .focused($focusedField, equals: index)
                            .onChange(of: otpFields[index]) { oldValue, newValue in
                                
                                let filtered = newValue.filter { $0.isNumber }

                                if filtered.count > 1 {
                                    handlePaste(filtered)
                                    return
                                }

                                if filtered.isEmpty {
                                    otpFields[index] = ""
                                    if index > 0 { focusedField = index - 1 }
                                    return
                                }

                                otpFields[index] = String(filtered.prefix(1))

                                if index < 5 {
                                    focusedField = index + 1
                                } else {
                                    focusedField = nil
                                }
                            }
                    }
                }
                .padding(.bottom, 45)
                
                // ปุ่มยืนยัน
                NavigationLink(destination: OTPConfirmView()) {
                    Text("ยืนยัน")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 155, height: 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                }
                
                HStack(spacing: 8){
                    Text("ยังไม่ได้รับรหัส?")
                        .font(.noto(15,weight: .medium))
                        .foregroundColor(.black)
                        
                    Button(action: {
                        print("New OTP")
                    }) {
                        Text("ส่งรหัสใหม่")
                            .font(.noto(15,weight: .bold))
                            .foregroundColor(.mainColor)
                            .underline(color: .mainColor)
                    }
                }
                .padding(.top,15)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .onAppear { focusedField = 0 } // เริ่มที่ช่องแรก
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }

    // ฟังก์ชันกระจายตัวเลขเมื่อมีการวาง (paste)
    private func handlePaste(_ value: String) {
        let digits = value.filter { $0.isNumber }
        let limited = String(digits.prefix(6)) // จำกัดสูงสุด 6 ตัว

        for i in 0..<6 {
            if i < limited.count {
                otpFields[i] = String(limited[limited.index(limited.startIndex, offsetBy: i)])
            } else {
                otpFields[i] = ""
            }
        }

        focusedField = limited.count < 6 ? limited.count : nil
    }
}

#Preview {
    OTPConfirmView()
}
