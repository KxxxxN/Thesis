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
    
    @Published var isSubmitted = false
    
    func validateEmail() {
        self.isSubmitted = true
        
        let trimmed = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            emailError = "กรุณากรอกอีเมลใหม่"
        } else if ValidationHelper.isValidEmail(trimmed) {
            emailError = nil
            // TODO: เรียก API เพื่อส่ง OTP ไปยังอีเมลใหม่
            navigateToOTP = true
        } else {
            emailError = "รูปแบบอีเมลไม่ถูกต้อง"
        }
    }
    
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            emailError = nil
        }
    }
}
