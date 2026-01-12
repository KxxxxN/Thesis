//
//  NewPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//


import Foundation
import SwiftUI

class NewPasswordViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var oldPassword: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // MARK: - UI States
    @Published var isOldPasswordVisible: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    
    // MARK: - Validation States
    @Published var isOldPasswordValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var isSubmitted: Bool = false
    
    @Published var showOldError = false
        @Published var showNewError = false
        @Published var showConfirmError = false
    
    // MARK: - Navigation
    @Published var navigateToLogin: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // MARK: - Password Checklist Helpers (ดึงจาก ValidationHelper)
    // ใช้สำหรับแสดง Checklist 5 ข้อในหน้า View
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    // ตรวจสอบว่ารหัสผ่านใหม่ถูกต้องตามกฎ และรหัสผ่านใหม่ต้องตรงกับยืนยัน
    var isNewPasswordFormValid: Bool {
        return ValidationHelper.isPasswordValid(password) && (password == confirmPassword) && !password.isEmpty
    }
    
    func clearErrorOnTyping(for field: String) {
        // ✅ ไม่ต้องไปยุ่งกับ isSubmitted เพื่อให้ช่องอื่นยังแดงอยู่
        switch field {
        case "old":
            isOldPasswordValid = true
            showOldError = false // หายเฉพาะช่องนี้
        case "new":
            isPasswordValid = true
            showNewError = false
        case "confirm":
            isConfirmPasswordValid = true
            showConfirmError = false
        default:
            break
        }
    }
    
    func validateAndSave() -> Bool {
        // 1. ตรวจสอบรหัสผ่านเก่า (สมมติว่ารหัสผ่านเก่าต้องเป็น "12345678" สำหรับ Thesis)
        // ในระบบจริงต้องส่งไปเช็คที่ Database/API
        let currentStoredPassword = "12345678" 
        isOldPasswordValid = (oldPassword == currentStoredPassword)
        
        // 2. ตรวจสอบรูปแบบรหัสผ่านใหม่
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        
        // 3. ตรวจสอบว่ารหัสผ่านใหม่ตรงกับช่องยืนยันไหม
        if ValidationHelper.isEmpty(confirmPassword) {
            isConfirmPasswordValid = false
        } else {
            isConfirmPasswordValid = (password == confirmPassword)
        }
        
        return isOldPasswordValid && isPasswordValid && isConfirmPasswordValid
    }
    
    func clearErrorOnTyping() {
        if isSubmitted {
            isSubmitted = false
        }
        // ✅ ล้างค่า Valid ของทุกช่องให้กลับเป็น true เพื่อให้ขอบแดงหายไปทันทีเมื่อเริ่มพิมพ์
        isOldPasswordValid = true
        isPasswordValid = true
        isConfirmPasswordValid = true
        
        // ✅ สั่งปิด Popup หาก User เริ่มพิมพ์ใหม่
        showErrorPopup = false
    }
    
    func saveNewPassword() {
        self.isSubmitted = true
        
        // รัน Validation
        let currentStoredPassword = "12345678"
        isOldPasswordValid = (oldPassword == currentStoredPassword)
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        isConfirmPasswordValid = !ValidationHelper.isEmpty(confirmPassword) && (password == confirmPassword)
        
        // ✅ สั่งให้โชว์ Error เฉพาะอันที่ผิด
        showOldError = !isOldPasswordValid
        showNewError = !isPasswordValid
        showConfirmError = !isConfirmPasswordValid
        
        if isOldPasswordValid && isPasswordValid && isConfirmPasswordValid {
            self.showSuccessAlert = true
        } else {
            self.showErrorPopup = true
        }
    }
        
    private func resetFields() {
        oldPassword = ""
        password = ""
        confirmPassword = ""
        isOldPasswordValid = true
        isPasswordValid = true
        isConfirmPasswordValid = true
    }
}
