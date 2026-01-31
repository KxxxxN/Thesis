//
//  RegisterViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    
    // ข้อมูลจาก View (อิงตาม @StateObject ในโค้ดของคุณ)
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isPrivacyAccepted = false
    
    // UI States
    @Published var isRegisterSubmitted = false
    @Published var showSuccessPopup = false
    @Published var showErrorPopup = false
    @Published var showPrivacyPopup = false
    @Published var isPasswordVisible = false
    @Published var isConfirmPasswordVisible = false
    
    // Validation States (ตัวอย่าง)
    @Published var isFirstNameValid = true
    @Published var isLastNameValid = true
    @Published var isEmailValid = true
    @Published var isPhoneValid = true
    @Published var isPasswordValid = true
    @Published var isConfirmPasswordValid = true
    
    private var db = Firestore.firestore()
    
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
        self.isRegisterSubmitted = true
        
        // 1. ตรวจสอบข้อมูลใน Form ก่อน
        if validateFormRegister() {
            // ใช้ Task เพื่อรองรับ async function
            Task { [weak self] in
                guard let self = self else { return }
                
                do {
                    // 2. สร้าง User ผ่าน Manager (ส่ง Email และ Password)
                    let authResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                    
                    // 3. เมื่อสร้างสำเร็จ นำ UID ที่ได้ไปบันทึกข้อมูลส่วนตัวลง Firestore
                    await saveUserData(uid: authResult.uid)
                    
                    // 4. อัปเดต UI เมื่อทุกอย่างสำเร็จ
                    await MainActor.run {
                        self.showSuccessPopup = true
                    }
                } catch {
                    // ❌ กรณีเกิด Error (เช่น อีเมลซ้ำ หรือรหัสผ่านไม่ปลอดภัย)
                    await MainActor.run {
                        print("Registration Error: \(error.localizedDescription)")
                        self.showErrorPopup = true
                    }
                }
            }
        } else {
            print("Form is invalid")
        }
    }
        
    private func saveUserData(uid: String) async {
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email.lowercased(),
            "phone": phone,
            "createdAt": FieldValue.serverTimestamp(),
            "role": "user"
        ]
        
        do {
            // ใช้ try await แทนการใช้ Closure
            try await db.collection("users").document(uid).setData(userData)
            print("Firestore: Save user data success")
        } catch {
            print("Firestore Error: \(error.localizedDescription)")
            await MainActor.run {
                self.showErrorPopup = true
            }
        }
    }
}
