//
//  RegisterViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//


// RegisterViewModel.swift

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isPrivacyAccepted: Bool = false
    @Published var showPrivacyPopup: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var isFormSubmitted: Bool = false
    
    @Published var isFirstNameValid: Bool = true
    @Published var isLastNameValid: Bool = true
    @Published var isEmailValid: Bool = true
    @Published var isPhoneValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    
    // MARK: - Phone
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^(0[0-9]{2}-?)([0-9]{3}-?)([0-9]{4})$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    // MARK: - Email
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Name & Lastname
    func isNameValid(name: String) -> Bool {
        if name.isEmpty { return true }
        
        // 2. ตรวจสอบว่ามีแต่ภาษาไทยหรือไม่ (ก-ฮ, Space, Hyphen)
        let thaiRegex = "^[\\p{Thai}\\s\\-]+$"
        let isThaiOnly = NSPredicate(format: "SELF MATCHES %@", thaiRegex).evaluate(with: name)
        
        // 3. ตรวจสอบว่ามีแต่ภาษาอังกฤษหรือไม่ (a-z, A-Z, Space, Hyphen)
        let englishRegex = "^[a-zA-Z\\s\\-]+$"
        let isEnglishOnly = NSPredicate(format: "SELF MATCHES %@", englishRegex).evaluate(with: name)
        
        // 4. ถ้าเป็นภาษาใดภาษาหนึ่งเท่านั้น ให้ถือว่าถูกต้อง
        return isThaiOnly || isEnglishOnly
    }
    
    // MARK: - Password
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
    
    // MARK: - Main Validation Logic
    // เพิ่ม @discardableResult เพื่อให้ Xcode ไม่เตือนว่าผลลัพธ์ไม่ได้ถูกใช้ หากมีการเรียกใช้ฟังก์ชันนี้เพื่ออัปเดตสถานะเท่านั้น
    @discardableResult
    func validateForm() -> Bool {
        // ตรวจสอบว่าช่องว่างหรือไม่
        isFirstNameValid = !firstName.isEmpty
        isLastNameValid = !lastName.isEmpty
        isEmailValid = !email.isEmpty
        isPhoneValid = !phone.isEmpty
        isPasswordValid = !password.isEmpty
        isConfirmPasswordValid = !confirmPassword.isEmpty
        
        // MARK: - ตรวจสอบความถูกต้องของชื่อ/นามสกุล
        if isFirstNameValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isFirstNameValid = isNameValid(name: firstName)
        }
        if isLastNameValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isLastNameValid = isNameValid(name: lastName)
        }
        
        // MARK: - ตรวจสอบรหัสผ่านตามเงื่อนไขใหม่
        if !password.isEmpty {
            isPasswordValid = isPasswordValid(password: password)
        } else {
            isPasswordValid = false
        }
        // MARK: - ตรวจสอบว่ารหัสผ่านและยืนยันรหัสผ่านตรงกันหรือไม่
        if isPasswordValid && isConfirmPasswordValid && !password.isEmpty && !confirmPassword.isEmpty {
            if password != confirmPassword {
                isPasswordValid = false // ตั้งให้ช่อง Password เป็น Invalid ด้วย
                isConfirmPasswordValid = false
            } else {
                // ถ้าตรงกัน ให้ตั้งเป็น true อีกครั้งหากก่อนหน้านี้ถูกตั้งเป็น false
                isConfirmPasswordValid = true
            }
        }
        
        // MARK: - ตรวจสอบรูปแบบอีเมล
        if isEmailValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isEmailValid = isValidEmail(email: email)
        }
        
        // MARK: - ตรวจสอบรูปแบบเบอร์โทรศัพท์
        if isPhoneValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isPhoneValid = isValidPhone(phone: phone)
        }
        
        // คืนค่า true ถ้าทุกช่องถูกต้อง
        return isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid && isPrivacyAccepted
    }
}
