//
//  OTPConfirmViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 2/12/2568 BE.
//



import Foundation
import SwiftUI

class OTPConfirmViewModel: ObservableObject {
    @Published var userEmail: String = ""
    @Published var displayRefCode: String = ""
    
    // สถานะสำหรับช่องกรอก OTP
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var isFieldInvalid: [Bool] = Array(repeating: false, count: 6)
    
    @Published var isSubmitted: Bool = false
//    @Published var isLoading: Bool = false
    
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var showIncompleteError: Bool = false
    @Published var showIncorrectError: Bool = false
    @Published var errorMessage: String = ""
    
    
    @Published var navigateToChangePW: Bool = false
    @Published var navigateToNewPW: Bool = false
    
//    private let correctOTP = "123456"
    
    // Computed Property: รหัส OTP ทั้งหมดที่กรอก
    var fullOTP: String {
        otpFields.joined()
    }
    
    // Computed Property: ข้อความ Error ที่ควรแสดง
//    var errorMessage: String {
//        if showIncompleteError {
//            return "กรุณากรอกรหัส OTP ให้ครบถ้วน"
//        } else if showIncorrectError {
//            return "รหัส OTP ไม่ถูกต้อง"
//        }
//        return ""
//    }
    
    // Computed Property: ควรแสดง Error หรือไม่
    var shouldShowError: Bool {
        return isSubmitted && (showIncompleteError || showIncorrectError)
    }

    func handleOTPChange(index: Int, newValue: String) -> Int? {
        if isSubmitted { isSubmitted = false }
        
        // 1. ถ้าเป็นการลบ (newValue ว่าง)
        if newValue.isEmpty {
            return index > 0 ? index - 1 : 0
        }
        
        // 2. ถ้ามีการพิมพ์ (เอาเฉพาะตัวเลขตัวล่าสุด)
        let filtered = newValue.filter { $0.isNumber }
        if let lastDigit = filtered.last {
            otpFields[index] = String(lastDigit) // บังคับให้มีแค่ตัวเดียว
            isFieldInvalid[index] = false
            
            // ส่ง Index ถัดไปกลับไปให้ View จัดการ Focus
            return index < 5 ? index + 1 : nil
        }
        
        return index
    }
    // ฟังก์ชันเสริมสำหรับ Paste (ปรับให้ return index)
    private func handlePasteReturningIndex(_ value: String) -> Int? {
        let digits = Array(value.filter { $0.isNumber }.prefix(6))
        for i in 0..<6 {
            if i < digits.count {
                otpFields[i] = String(digits[i])
            } else {
                otpFields[i] = ""
            }
        }
        return digits.count < 6 ? digits.count : nil
    }
    
    // ฟังก์ชันกระจายตัวเลขเมื่อมีการวาง (paste)
    func handlePaste(_ value: String, focusedField: inout Int?) {
        let digits = value.filter { $0.isNumber }
        let limited = String(digits.prefix(6)) // จำกัดสูงสุด 6 ตัว
        
        for i in 0..<6 {
            if i < limited.count {
                otpFields[i] = String(limited[limited.index(limited.startIndex, offsetBy: i)])
            } else {
                otpFields[i] = ""
            }
        }
        
        focusedField = limited.count < 6 ? limited.count : nil
        
        showIncompleteError = false
        showIncorrectError = false
    }
    
    func resetOTPFields() {
        otpFields = Array(repeating: "", count: 6)
        isFieldInvalid = Array(repeating: false, count: 6)
        showIncorrectError = false
        showIncompleteError = false
        isSubmitted = false
    }
    
    // เพิ่มฟังก์ชันนี้ใน OTPConfirmViewModel
    func resendOTP() {
        Task {
            do {
                // เรียกส่ง OTP อีกครั้งโดยใช้อีเมลเดิม
                let newRef = try await AuthenticationManager.shared.sendCustomOTP(email: self.userEmail)
                
                await MainActor.run {
                    self.displayRefCode = newRef // อัปเดตรหัสอ้างอิงใหม่บนหน้าจอ
                    self.resetOTPFields() // ล้างช่องกรอกเดิม
                    // อาจจะเพิ่ม alert แจ้งเตือนว่า "ส่งรหัสใหม่สำเร็จ"
                }
            } catch {
                print("Resend Error: \(error.localizedDescription)")
            }
        }
    }
    
    // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม "ยืนยัน"
    func verifyOTP(source: OTPSource) {
        self.isSubmitted = true
        self.showIncompleteError = false
        self.showIncorrectError = false
        self.isFieldInvalid = Array(repeating: false, count: 6)
        
        // 1. ตรวจสอบว่ากรอกครบไหม
        if fullOTP.count < 6 {
            self.showIncompleteError = true
            self.errorMessage = "กรุณากรอกรหัส OTP ให้ครบถ้วน"
            for i in 0..<6 { isFieldInvalid[i] = otpFields[i].isEmpty }
            return
        }
        
        // 2. ตรวจสอบรหัสกับ Firebase Firestore
//        self.isLoading = true
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // เรียกใช้ Manager ที่เราเขียนไว้ก่อนหน้า
                let isCorrect = try await AuthenticationManager.shared.verifyCustomOTP(
                    email: self.userEmail,
                    enteredOTP: self.fullOTP
                )
                
                await MainActor.run {
//                    self.isLoading = false
                    if isCorrect {
                        // ✅ รหัสถูกต้อง
                        self.handleSuccessNavigation(source: source)
                    } else {
                        // ❌ รหัสผิด หรือ หมดอายุ
                        self.showIncorrectError = true
                        self.errorMessage = "รหัส OTP ไม่ถูกต้องหรือหมดอายุ"
                        self.isFieldInvalid = Array(repeating: true, count: 6)
                        
                        if source == .changeEmail {
                            withAnimation { self.showErrorPopup = true }
                        }
                    }
                }
            } catch {
                await MainActor.run {
//                    self.isLoading = false
                    self.showIncorrectError = true
                    self.errorMessage = "เกิดข้อผิดพลาดในการตรวจสอบรหัส"
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleSuccessNavigation(source: OTPSource) {
        switch source {
        case .forgotPassword: navigateToChangePW = true
        case .confirmEmail: navigateToNewPW = true
        case .changeEmail: showSuccessPopup = true
        }
    }
}
