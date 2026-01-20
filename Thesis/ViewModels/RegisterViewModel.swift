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
    @Published var showErrorPopup: Bool = false
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
    
    func clearError(for field: String) {
        switch field {
        case "firstName": isFirstNameValid = true
        case "lastName": isLastNameValid = true
        case "email": isEmailValid = true
        case "phone": isPhoneValid = true
        case "password": isPasswordValid = true
        case "confirmPassword": isConfirmPasswordValid = true
        default: break
        }
        
        // หมายเหตุ: ไม่ต้องสั่ง isRegisterSubmitted = false แล้ว
        // เพราะเราต้องการให้ช่องอื่นๆ ที่ยังไม่ได้แก้ ยังโชว์ Error ค้างไว้อยู่
    }
    
    
    @discardableResult
    func validateFormRegister() -> Bool {
        // 1. ใส่ Logic การเช็คแต่ละช่องที่คุณมีอยู่แล้วตรงนี้
        isFirstNameValid = !firstName.isEmpty && ValidationHelper.isNameValid(name: firstName)
        isLastNameValid = !lastName.isEmpty && ValidationHelper.isNameValid(name: lastName)
        isEmailValid = !email.isEmpty && ValidationHelper.isValidEmail(email)
        isPhoneValid = !phone.isEmpty && ValidationHelper.isValidPhone(phone)
        isPasswordValid = !password.isEmpty && ValidationHelper.isPasswordValid(password)
        isConfirmPasswordValid = !confirmPassword.isEmpty && (password == confirmPassword)
        
        // 2. ✅ นำส่วนที่ถามมาวางไว้ตรงนี้ (บรรทัดสุดท้ายของฟังก์ชัน)
        let isDataValid = isFirstNameValid &&
                         isLastNameValid &&
                         isEmailValid &&
                         isPhoneValid &&
                         isPasswordValid &&
                         isConfirmPasswordValid
        
        // คืนค่าผลลัพธ์รวม (ต้องติ๊กยอมรับ Privacy ด้วยถึงจะผ่าน)
        return isDataValid && isPrivacyAccepted
    }
    
    func register() {
        // 1. สั่งเปิดสถานะ Submit เพื่อให้ขอบแดงทำงาน
        self.isRegisterSubmitted = true
        
        // 2. ตรวจสอบความถูกต้องของข้อมูลทั้งหมด
        if validateFormRegister() {
            // ✅ กรณีข้อมูลถูกต้องทั้งหมด
            self.showSuccessPopup = true
        } else {
            // ❌ กรณีข้อมูลไม่ถูกต้อง หรือลืมติ๊ก Privacy
            self.showErrorPopup = true
        }
    }
}
