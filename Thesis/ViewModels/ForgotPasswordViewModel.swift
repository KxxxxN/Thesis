//
//  ForgotPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import SwiftUI
import Combine

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var emailForgotPassword: String = ""
    @Published var emailErrorForgot: String? = nil
    @Published var refCodeGenerated: String = ""
    
    @Published var isForgotSubmitted: Bool = false
    
    @AppStorage("navigateToOTP") var navigateToOTP = false
    
    // MARK: - Validation
    
    func clearError() {
        emailErrorForgot = nil
        isForgotSubmitted = false
    }
    
    @discardableResult
    func validateFormForgot() -> Bool {
        emailErrorForgot = nil
        
        if emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailErrorForgot = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
            return false
        } else if !ValidationHelper.isValidEmail(emailForgotPassword) {
            emailErrorForgot = "รูปแบบอีเมลไม่ถูกต้อง"
            return false
        }
        return true
    }
    
//    func forgotPassword() {
//        self.isForgotSubmitted = true
//        
//        if validateFormForgot() {
//            // จำลองการตรวจสอบกับ Database
//            let emailForgot = "user@gmail.com"
//            
//            if emailForgotPassword == emailForgot {
//                navigateToOTP = true
//            } else {
//                emailErrorForgot = "อีเมลนี้ยังไม่ได้ลงทะเบียน"
//            }
//        }
//    }
    func forgotPassword() {
        self.isForgotSubmitted = true
        self.emailErrorForgot = nil
        
        Task {
            do {
                // เรียกใช้ sendCustomOTP และรับค่า refCode กลับมา
                let ref = try await AuthenticationManager.shared.sendCustomOTP(email: emailForgotPassword)
                
                await MainActor.run {
                    self.refCodeGenerated = ref
                    self.navigateToOTP = true
                }
            } catch {
                await MainActor.run {
                    self.emailErrorForgot = error.localizedDescription
                }
            }
        }
    }
}
