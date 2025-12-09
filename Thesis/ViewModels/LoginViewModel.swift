//
//  LoginViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
        
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isPasswordVisible: Bool = false
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
    @Published var loginErrorMessage: String? = nil
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    @discardableResult
    func validateFormLogin() -> Bool {
        
        emailError = nil
        passwordError = nil
        
        var allFieldsValid = true
        
        // 2. ตรวจสอบอีเมล
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailError = "กรุณากรอกอีเมล" // กำหนดข้อความเฉพาะ
            allFieldsValid = false
        }
        
        // 3. ตรวจสอบรหัสผ่าน
        if password.isEmpty {
            passwordError = "กรุณากรอกรหัสผ่าน" // กำหนดข้อความเฉพาะ
            allFieldsValid = false
        }
        
        return allFieldsValid
    }
    
    func login() {
        loginErrorMessage = nil
        
        let isFormValid = validateFormLogin()
        
        if !isFormValid {
            print("Validation Failed: Empty fields")
            return
        }
        
        let validUsername = "user@example.com"
        let validPassword = "12345678"
        
        if email == validUsername && password == validPassword {
            isLoggedIn = true
            print("Login Successful")
        } else {
            loginErrorMessage = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
            emailError = loginErrorMessage
            passwordError = loginErrorMessage
            
            print("Login Failed: Incorrect credentials")
        }
    }
}
