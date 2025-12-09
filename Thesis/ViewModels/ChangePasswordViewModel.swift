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
    @Published var passwordsMatch: Bool = true
    
    @Published var navigateToLogin: Bool = false
    @AppStorage("navigateToLogin") var navigateTologin = false
    // Computed Property: ตรวจสอบว่ารหัสผ่านใหม่ผ่านเงื่อนไข Checklist ทั้งหมดหรือไม่
    
    var isFormValid: Bool {
        // ต้องผ่านเงื่อนไขรูปแบบ AND ต้องตรงกัน
        return isPasswordValid(password: password) && (password == confirmPassword) && !password.isEmpty
    }
            
    // MARK: - Validation Functions (Logic สำหรับ Checklist 5 ข้อ)
    func isPasswordValid(password: String) -> Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%&*_-]).{8,}$"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func hasMinimumLength(_ password: String) -> Bool {
        return password.count >= 8
    }

    func hasUppercase(_ password: String) -> Bool {
        let regex = ".*[A-Z]+.*"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }

    func hasLowercase(_ password: String) -> Bool {
        let regex = ".*[a-z]+.*"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }

    func hasDigit(_ password: String) -> Bool {
        let regex = ".*[0-9]+.*"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }

    func hasSpecialCharacter(_ password: String) -> Bool {
        // อักขระพิเศษ: !@#$%&*_-
        let regex = ".*[!@#$%&*_-]+.*"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    // MARK: - Action & Confirmation Validation
    func validateFormChangePassword() -> Bool {
        
        // 1. ตรวจสอบว่าช่องว่างเปล่าหรือไม่ (Required check)
        isPasswordValid = !password.isEmpty
        isConfirmPasswordValid = !confirmPassword.isEmpty
        
        // 2. ตรวจสอบรูปแบบ (Format Validation)
        if !password.isEmpty {
            let isFormatValid = isPasswordValid(password: password)
            self.isPasswordValid = isFormatValid // ตั้งค่าตามผลการตรวจสอบรูปแบบ
        }
        
        // 3. ตรวจสอบการตรงกัน (Matching Validation)
        var isMatch = false
        if !password.isEmpty && !confirmPassword.isEmpty {
            isMatch = (password == confirmPassword)
            // ตั้งค่า isConfirmPasswordValid ตามผลการ Match และต้องผ่านรูปแบบ
            self.isConfirmPasswordValid = isMatch && self.isPasswordValid
        }
        
        // 4. ผลลัพธ์รวม: ต้องผ่านรูปแบบ, ต้องไม่ว่างเปล่า, และต้องตรงกัน
        let finalResult = self.isPasswordValid && self.isConfirmPasswordValid && isMatch && !password.isEmpty
        
        return finalResult
    }
    
    func changePassword() {
        // 1. เรียกตรวจสอบฟอร์มก่อนดำเนินการ
        if validateFormChangePassword() {
            // MARK: - 💡 Logic การเปลี่ยนรหัสผ่านสำเร็จ
            
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
            // หากฟอร์มไม่ถูกต้อง: อาจมีการแสดงข้อความแจ้งเตือนเพิ่มเติมที่นี่
            print("Form validation failed. Please check the fields.")
        }
    }
}
