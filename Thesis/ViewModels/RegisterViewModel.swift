//
//  RegisterViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    // MARK: - Input Fields
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // MARK: - UI States
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isPrivacyAccepted: Bool = false
    @Published var showPrivacyPopup: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var isRegisterSubmitted: Bool = false
    
    // MARK: - Validation States (สำหรับแสดงสีแดง/ข้อความเตือนใน UI)
    @Published var isFirstNameValid: Bool = true
    @Published var isLastNameValid: Bool = true
    @Published var isEmailValid: Bool = true
    @Published var isPhoneValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    // MARK: - Password Checklist Helpers
    // เรียกใช้ ValidationHelper เพื่อเช็คเงื่อนไขแต่ละข้อสำหรับแสดงใน UI
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    
    @discardableResult
    func validateFormRegister() -> Bool {
        // 1. ตรวจสอบชื่อและนามสกุล (ต้องไม่ว่าง และ เป็นภาษาเดียวตามเงื่อนไข)
        isFirstNameValid = !firstName.isEmpty && ValidationHelper.isNameValid(name: firstName)
        isLastNameValid = !lastName.isEmpty && ValidationHelper.isNameValid(name: lastName)
        
        // 2. ตรวจสอบอีเมล
        isEmailValid = !email.isEmpty && ValidationHelper.isValidEmail(email)
        
        // 3. ตรวจสอบเบอร์โทรศัพท์
        isPhoneValid = !phone.isEmpty && ValidationHelper.isValidPhone(phone)
        
        // 4. ตรวจสอบความแข็งแรงของรหัสผ่าน
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        
        // 5. ตรวจสอบการยืนยันรหัสผ่าน
        if ValidationHelper.isEmpty(confirmPassword) {
            isConfirmPasswordValid = false
        } else {
            // ต้องเหมือนกับรหัสผ่านหลัก
            isConfirmPasswordValid = (password == confirmPassword)
        }
        
        // บันทึกสถานะว่ามีการกด Submit แล้ว (เผื่อใช้โชว์ Error ทันที)
        isRegisterSubmitted = true
        
        // คืนค่า true เฉพาะเมื่อทุกอย่างถูกต้องและยอมรับเงื่อนไขแล้วเท่านั้น
        return isFirstNameValid &&
        isLastNameValid &&
        isEmailValid &&
        isPhoneValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        isPrivacyAccepted
    }
}
