//
//  ConfirmEmailViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//


import SwiftUI

class ConfirmEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailError: String? = nil
    @Published var navigateToOTP = false
    @Published var refCodeGenerated: String = ""
    
    @Published var isSubmitted = false
    
    func verifyEmailBeforeChange() {
        self.isSubmitted = true
        
        if email.isEmpty {
            emailError = "กรุณากรอกอีเมล"
            return
        }
        
        Task {
            do {
                // เรียกฟังก์ชันเพื่อส่ง OTP และรับค่า refCode
                let ref = try await AuthenticationManager.shared.sendCustomOTP(email: email)
                
                await MainActor.run {
                    self.refCodeGenerated = ref // ✅ บันทึกค่า Ref
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
