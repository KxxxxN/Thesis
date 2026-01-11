//
//  ChangePasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 2/12/2568 BE.
//


import Foundation
import SwiftUI

class ChangePasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
        
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isChangePasswordSubmitted: Bool = false
        
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
        
    @Published var navigateToLogin: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // MARK: - Password Checklist Helpers (เรียกใช้จาก Helper)
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    var isFormValid: Bool {
        return ValidationHelper.isPasswordValid(password) && (password == confirmPassword) && !password.isEmpty
    }
    
    func clearError(for field: String) {
        // เมื่อเริ่มพิมพ์ใหม่ ให้สถานะ Submit เป็น false เพื่อให้ระบบคำนวณ Error ใหม่
        // หรือจะเลือกคงค่าไว้แล้วเปลี่ยนแค่ Valid ของช่องนั้นๆ ก็ได้
        if field == "password" {
            isPasswordValid = true
        } else if field == "confirmPassword" {
            isConfirmPasswordValid = true
        }
        
        // หากต้องการให้พฤติกรรมเหมือน RegisterView ที่กรอบแดงหายทันทีที่พิมพ์
        // อาจจะต้องใช้ตัวแปรควบคุมแยก หรือเช็คผ่าน isChangePasswordSubmitted
    }
    
    // MARK: - Action & Confirmation Validation
    func validateFormChangePassword() -> Bool {
        isChangePasswordSubmitted = true
        
        // 1. ตรวจสอบรูปแบบรหัสผ่าน
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        
        // 2. ตรวจสอบการตรงกัน
        if ValidationHelper.isEmpty(confirmPassword) {
            isConfirmPasswordValid = false
        } else {
            isConfirmPasswordValid = (password == confirmPassword)
        }
        
        return isPasswordValid && isConfirmPasswordValid
    }
    
    func changePassword() {
        if validateFormChangePassword() {
            print("Password successfully changed.")
            withAnimation {
                self.showSuccessPopup = true
            }
            // รีเซ็ตค่าหลังจากสำเร็จ
            password = ""
            confirmPassword = ""
            isChangePasswordSubmitted = false // รีเซ็ตสถานะการส่ง
        } else {
            withAnimation {
                self.showErrorPopup = true
            }
        }
    }
}
