//
//  ConfirmPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//


import SwiftUI

class ConfirmPasswordViewModel: ObservableObject {
    @Published var password = ""
    @Published var passwordError: String? = nil
    @Published var isPasswordVisible = false
    @Published var navigateToNextStep = false
    
    // ✅ เพิ่มสถานะเพื่อเช็คว่ามีการกดปุ่มยืนยันหรือยัง
    @Published var isSubmitted = false

    func verifyPassword() {
        // ✅ ตั้งค่าเป็น true ทันทีที่กดปุ่ม
        self.isSubmitted = true
        
        if password.isEmpty {
            passwordError = "กรุณากรอกรหัสผ่าน"
        } else if password == "12345678" {
            passwordError = nil
            navigateToNextStep = true
        } else {
            passwordError = "รหัสผ่านไม่ถูกต้อง"
        }
    }
    
    // ✅ ฟังก์ชันสำหรับล้างค่าเมื่อเริ่มพิมพ์ใหม่
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            passwordError = nil
        }
    }
}
