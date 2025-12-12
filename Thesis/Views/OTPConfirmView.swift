//
//  OTPConfirmView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

struct OTPConfirmView: View {
    // ใช้ @StateObject เพื่อสร้างและจัดการ ViewModel
    @StateObject private var viewModel = OTPConfirmViewModel()
    
    // ย้าย FocusState มาที่ View หลักเพื่อส่งไปที่ Component
    @FocusState private var focusedField: Int?
    
    @AppStorage("navigateToChangePW") var appStorageNavigateToChangePW = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header (เดิม)
                ZStack {
                    Text("ยืนยันรหัส OTP")
                        .font(.noto(25, weight: .bold))

                    HStack {
                        BackButton()
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 65)

                Text("ใส่รหัสที่ส่งไปยังอีเมลของคุณ")
                    .font(.noto(20, weight: .semibold))
                    .padding(.bottom, 18)

                // ** Component ช่อง OTP **
                OTPInputView(viewModel: viewModel, focusedField: $focusedField)
                    .padding(.bottom, 15)

                // ** ส่วนแสดงผล Error **
                Text(viewModel.errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .frame(height: 15)
                    .padding(.bottom,0)
                    .opacity(viewModel.shouldShowError ? 1 : 0)
                
                HStack(spacing: 5){
                    Text("รหัสอ้างอิง :")
                        .font(.noto(15, weight: .medium))
                        .foregroundColor(Color.placeholderColor)
                    
                    let refCode = "A9F4K2"
                    Text(refCode)
                        .font(.noto(15, weight: .medium))
                        .foregroundColor(Color.placeholderColor)
                    
                }
                .padding(.bottom,18)
                    
                // ปุ่มยืนยัน
//                Button(action: {
//                    focusedField = nil
//                    viewModel.verifyOTP()
//                }) {
//                    Text("ยืนยัน")
//                        .font(.noto(20, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 155, height: 49)
//                        .background(Color.mainColor)
//                        .cornerRadius(20)
//                }
                
                PrimaryButton(
                    title: "ยืนยัน",
                    action: {
                        focusedField = nil
                        viewModel.verifyOTP()
                    },
                    width: 155, // ความกว้างของปุ่ม
                    height: 49 // ความสูงของปุ่ม
                )
                
                HStack(spacing: 8){
                    Text("ยังไม่ได้รับรหัส?")
                        .font(.noto(15,weight: .medium))
                        .foregroundColor(.black)
                        
                    Button(action: {
                        print("New OTP")
                        // TODO: Implement Resend OTP logic in ViewModel
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
            .onAppear { focusedField = 0 }
            
            // ผูกสถานะการนำทางจาก ViewModel กับ AppStorage/Navigation
            .onChange(of: viewModel.navigateToChangePW) { oldValue, newValue in
                if newValue {
                    appStorageNavigateToChangePW = true
                }
            }
            .navigationDestination(isPresented: $appStorageNavigateToChangePW) {
                // สมมติว่า ChangePasswordView() มีอยู่จริง
                // ถ้ามีการใช้ NavigationStack/Path ที่ซับซ้อนกว่านี้อาจต้องใช้ NavigationLink หรือ Path Array
                ChangePasswordView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OTPConfirmView()
}
