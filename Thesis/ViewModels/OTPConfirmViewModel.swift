//
//  OTPConfirmViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 2/12/2568 BE.
//



import Foundation
import SwiftUI

class OTPConfirmViewModel: ObservableObject {
    // สถานะสำหรับช่องกรอก OTP
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var isFieldInvalid: [Bool] = Array(repeating: false, count: 6)
    
    @Published var isSubmitted: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var showIncompleteError: Bool = false
    @Published var showIncorrectError: Bool = false
    
    
    @Published var navigateToChangePW: Bool = false
    @Published var navigateToNewPW: Bool = false
    
    // *** จำลองรหัส OTP ที่ถูกต้อง (สามารถเปลี่ยนได้) ***
    private let correctOTP = "123456"
    
    // Computed Property: รหัส OTP ทั้งหมดที่กรอก
    var fullOTP: String {
        otpFields.joined()
    }
    
    // Computed Property: ข้อความ Error ที่ควรแสดง
    var errorMessage: String {
        if showIncompleteError {
            return "กรุณากรอกรหัส OTP ให้ครบถ้วน"
        } else if showIncorrectError {
            return "รหัส OTP ไม่ถูกต้อง"
        }
        return ""
    }
    
    // Computed Property: ควรแสดง Error หรือไม่
    var shouldShowError: Bool {
        // ✅ แสดง Error ต่อเมื่อกด Submit แล้วเท่านั้น
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
        
        // ตั้งค่า focus ไปยังช่องถัดไป หรือซ่อนคีย์บอร์ด
        focusedField = limited.count < 6 ? limited.count : nil
        
        // ล้างสถานะ Error ทันทีที่ผู้ใช้มีการวาง
        showIncompleteError = false
        showIncorrectError = false
    }
    
    func resetOTPFields() {
        otpFields = Array(repeating: "", count: 6)
        isFieldInvalid = Array(repeating: false, count: 6)
        showIncorrectError = false
        showIncompleteError = false
        isSubmitted = false // ✅ รีเซ็ตสถานะ Submit ด้วย
    }
    
    // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม "ยืนยัน"
    func verifyOTP(source: OTPSource) {
        // ✅ บันทึกว่ามีการกด Submit แล้ว
        self.isSubmitted = true
        
        showIncompleteError = false
        showIncorrectError = false
        isFieldInvalid = Array(repeating: false, count: 6)
        
        if fullOTP.count < 6 {
            showIncompleteError = true
            for i in 0..<6 { isFieldInvalid[i] = otpFields[i].isEmpty }
        } else {
            if fullOTP == correctOTP {
                switch source {
                case .forgotPassword: navigateToChangePW = true
                case .confirmEmail: navigateToNewPW = true
                case .changeEmail: showSuccessPopup = true
                }
            } else {
                showIncorrectError = true
                isFieldInvalid = Array(repeating: true, count: 6)
                
                // ✅ แสดง Error Popup เฉพาะเคสเปลี่ยนอีเมลเหมือนเดิม
                if source == .changeEmail {
                    withAnimation { self.showErrorPopup = true }
                }
            }
        }
    }
}
