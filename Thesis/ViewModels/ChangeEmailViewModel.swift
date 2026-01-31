//
//  ChangeEmailViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//


import SwiftUI

class ChangeEmailViewModel: ObservableObject {
    @Published var newEmail = ""
    @Published var emailError: String? = nil
    @Published var navigateToOTP = false
    @Published var refCodeGenerated: String = ""
    
    @Published var isSubmitted = false
    
    func validateEmail() {
        self.isSubmitted = true
        // เพิ่ม Logic ตรวจสอบรูปแบบ Email เบื้องต้น
        if newEmail.isEmpty {
            emailError = "กรุณากรอกอีเมล"
            return
        }
        
        Task {
            do {
                // สำหรับเคส "แก้ไขอีเมล" เราจะส่ง OTP ไปที่อีเมลใหม่ทันที
                // โดยเรียกใช้ Manager ตัวเดียวกับที่คุณเขียนไว้
                let ref = try await AuthenticationManager.shared.sendCustomOTP(email: newEmail)
                
                await MainActor.run {
                    self.refCodeGenerated = ref // ✅ เก็บค่า Ref ที่ได้
                    self.navigateToOTP = true
                }
            } catch {
                await MainActor.run {
                    self.emailError = error.localizedDescription
                }
            }
        }
    }
    
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            emailError = nil
        }
    }
}
