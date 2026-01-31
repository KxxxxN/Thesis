//
//  LoginViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
    @Published var isLoginSubmitted: Bool = false
    
    //    @Published var loginErrorMessage: String? = nil
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    private let db = Firestore.firestore()
    
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
        self.isLoginSubmitted = true
        
        if validateFormLogin() {
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    // ✅ กลับมาใช้มาตรฐาน Firebase Auth (เพราะรหัสผ่านจะถูกอัปเดตในระบบ Auth หลักแล้ว)
                    _ = try await AuthenticationManager.shared.signIn(email: email, password: password)
                    
                    await MainActor.run {
                        withAnimation { self.isLoggedIn = true }
                    }
                } catch {
                    await MainActor.run {
                        // หากยังไม่ได้กดลิงก์ในเมล หรือรหัสผิด จะเข้า Error ตรงนี้
                        self.emailError = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                        self.passwordError = "กรุณาตรวจสอบว่าได้ยืนยันรหัสใหม่ในอีเมลแล้ว"
                    }
                }
            }
        }
    }
}
