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
    
    // สถานะสำหรับจัดการ Error
    @Published var showIncompleteError: Bool = false
    @Published var showIncorrectError: Bool = false
    
    // สถานะสำหรับขอบแดงของแต่ละช่อง
    @Published var isFieldInvalid: [Bool] = Array(repeating: false, count: 6)
    
    // สถานะสำหรับการนำทาง (ใช้ @Published แทน @AppStorage เพื่อให้ ViewModel ทดสอบได้ง่ายขึ้น)
    @Published var navigateToChangePW: Bool = false
    
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
        return showIncompleteError || showIncorrectError
    }

    // MARK: - Logic Functions

    // จัดการการเปลี่ยนแปลงค่าในช่อง OTP แต่ละช่อง (เช่น การกรอกทีละตัว)
    func handleOTPChange(index: Int, newValue: String, focusedField: inout Int?) {
        let filtered = newValue.filter { $0.isNumber }
        
        // 1. จัดการการวาง (Paste) - (ไม่มีการเปลี่ยนแปลง)
        if filtered.count > 1 {
            handlePaste(filtered, focusedField: &focusedField)
            return
        }
        
        // 2. จัดการการลบ (Delete) และ การกรอก (Type)
        if filtered.isEmpty {
            // A) การลบ (Delete/Backspace)
            
            // ล้างค่าในช่องปัจจุบัน
            otpFields[index] = ""
            
            // ย้าย Focus ไปช่องก่อนหน้าเสมอ (ถ้าไม่ใช่ช่องแรกสุด)
            if index > 0 {
                focusedField = index - 1
            } else {
                focusedField = 0 // ถ้าลบตัวแรก ให้ Focus อยู่ที่ช่อง 0
            }
            
        } else {
            // B) การกรอก (Type) - (ไม่มีการเปลี่ยนแปลง)
            
            otpFields[index] = String(filtered.prefix(1))
            
            isFieldInvalid[index] = false
            
            // เลื่อน focus ไปช่องถัดไป
            if index < 5 {
                focusedField = index + 1
            } else {
                focusedField = nil // ซ่อนคีย์บอร์ดเมื่อกรอกครบ
            }
        }
        
        // 3. ตรวจสอบ Live Validation (ตรรกะเดิม)
        if fullOTP.isEmpty {
            showIncompleteError = true
            showIncorrectError = false
            isFieldInvalid = Array(repeating: true, count: 6)
        } else {
            showIncompleteError = false
            showIncorrectError = false
            if !isFieldInvalid.allSatisfy({ $0 == false }) {
                isFieldInvalid = Array(repeating: false, count: 6)
            }
        }
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

    // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม "ยืนยัน"
    func verifyOTP() {
        // 1. ล้างสถานะ Error เดิม
        showIncompleteError = false
        showIncorrectError = false
        isFieldInvalid = Array(repeating: false, count: 6)

        if fullOTP.count < 6 {
            // 2. ถ้ากรอกไม่ครบ: แสดง Error "ไม่ครบถ้วน"
            showIncompleteError = true
            for i in 0..<6 {
                isFieldInvalid[i] = otpFields[i].isEmpty // ขอบแดงเฉพาะช่องที่ว่าง
            }
        } else {
            // 3. ถ้ากรอกครบ 6 หลัก: ตรวจสอบความถูกต้อง
            if fullOTP == correctOTP {
                // รหัสถูกต้อง: ดำเนินการต่อ (นำทาง)
                navigateToChangePW = true
            } else {
                // รหัสไม่ถูกต้อง: แสดง Error "ไม่ถูกต้อง"
                showIncorrectError = true
                isFieldInvalid = Array(repeating: true, count: 6) // ขอบแดงทุกช่อง
                print("OTP Incorrect: \(fullOTP)")
            }
        }
    }
}
