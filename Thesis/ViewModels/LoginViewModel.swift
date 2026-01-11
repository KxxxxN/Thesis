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
    
    @Published var isLoginSubmitted: Bool = false
    
//    @Published var loginErrorMessage: String? = nil
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    func clearError(for field: String) {
        if field == "email" {
            emailError = nil
        } else if field == "password" {
            passwordError = nil
        }
    }
    
    
    @discardableResult
    func validateFormLogin() -> Bool {
        emailError = nil
        passwordError = nil
        var allFieldsValid = true
        
        // 2. ตรวจสอบอีเมล
        if ValidationHelper.isEmpty(email) {
            emailError = "กรุณากรอกอีเมล" // กำหนดข้อความเฉพาะ
            allFieldsValid = false
        } else if !ValidationHelper.isValidEmail(email) {
            emailError = "รูปแบบอีเมลไม่ถูกต้อง"
            allFieldsValid = false
        }
        
        // 3. ตรวจสอบรหัสผ่าน
        if ValidationHelper.isEmpty(password) {
            passwordError = "กรุณากรอกรหัสผ่าน" // กำหนดข้อความเฉพาะ
            allFieldsValid = false
        }
        
        return allFieldsValid
    }
    
    func login() {
        // ✅ สั่งว่ามีการกด Submit แล้ว เพื่อให้ UI เริ่มโชว์ Error
        self.isLoginSubmitted = true
        
        if validateFormLogin() {
            let validUsername = "user@gmail.com"
            let validPassword = "12345678"
            
            if email == validUsername && password == validPassword {
                isLoggedIn = true
            } else {
                // กรณีรหัสผิด ให้แดงทั้งสองช่อง
                emailError = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                passwordError = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
            }
        }
    }
}
