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
    
    @Published var isSubmitted = false
    
    func verifyEmailBeforeChange() {
        self.isSubmitted = true
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            emailError = "กรุณากรอกอีเมล"
            return
        }
        
        if ValidationHelper.isValidEmail(trimmedEmail) {
            emailError = nil
            // TODO: เรียก API เพื่อส่ง OTP
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
