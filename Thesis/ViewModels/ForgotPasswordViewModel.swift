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
    
    @Published var forgotErrorMessage: String? = nil // ใช้สำหรับ Error ที่มาจาก Server/API
    @AppStorage("navigateToOTP") var navigateToOTP = false
    
    // MARK: - Validation
    
    @discardableResult
    func validateFormForgot() -> Bool {
        // 1. ล้างข้อความผิดพลาดเดิมก่อนตรวจสอบ
        emailErrorForgot = nil
        
        var allFieldsValid = true
        
        // 2. ตรวจสอบอีเมล
        if emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailErrorForgot = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
            allFieldsValid = false
        }
        
        return allFieldsValid
    }
    
    func forgotPassword() {
        forgotErrorMessage = nil
        
        let isValidForm = validateFormForgot()
        
        if !isValidForm {
            print("Validation Failed: Empty fields")
            return
        }
        
        let emailForgot = "user@example.com"
        
        if emailForgotPassword == emailForgot {
            navigateToOTP = true
            print("Email Forgot Password")
        } else {
            forgotErrorMessage = "อีเมลนี้ยังไม่ได้ลงทะเบียน"
            emailErrorForgot = forgotErrorMessage
            
            print("forgotPassword Failed")
        }
        
    }
}
