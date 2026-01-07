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
        // 1. เรียกตรวจสอบฟอร์มก่อนดำเนินการ
        if validateFormChangePassword() {
            
            // 2. ส่งข้อมูลรหัสผ่านไปยัง Backend (หรือ Logic การเปลี่ยนรหัสผ่านจริง)
            print("Password successfully changed.")
            
            // 3. ตั้งค่าการนำทางไปยังหน้า Login
            // นี่คือตัวแปร @AppStorage ที่จะใช้ในการนำทางใน View หลัก
            self.navigateToLogin = true
            
            // 4. อาจจะต้องการรีเซ็ต Field ต่างๆ หลังสำเร็จ
            password = ""
            confirmPassword = ""
            isPasswordVisible = false
            isConfirmPasswordVisible = false
            isPasswordValid = true
            isConfirmPasswordValid = true
            
        } else {
            print("Form validation failed. Please check the fields.")
        }
    }
}
