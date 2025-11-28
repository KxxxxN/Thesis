//
//  ForgotPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


// ForgotPasswordViewModel.swift

import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var isEmailValid: Bool = true // ใช้สำหรับ Client-side validation
    @Published var serverErrorMessage: String? = nil // ใช้สำหรับ Error ที่มาจาก Server/API
    
    // MARK: - Validation
    
    // ตรวจสอบรูปแบบอีเมล (ย้ายมาจาก RegisterViewModel)
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - API Handler
    
    // จัดการการตรวจสอบทั้งหมดและการเรียก API เพื่อขอ OTP
    func handleSendOTP(completion: @escaping (Bool) -> Void) {
        
        // 1. ตรวจสอบว่าช่องว่างหรือไม่
        if email.isEmpty {
            self.isEmailValid = false
            self.serverErrorMessage = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
            completion(false)
            return
        }
        
        // 2. ตรวจสอบรูปแบบอีเมล
        if !isValidEmail(email: self.email) {
            self.isEmailValid = false
            self.serverErrorMessage = nil 
            completion(false)
            return
        }
        
        // ถ้าผ่านการตรวจสอบรูปแบบแล้ว ให้ล้าง Error เก่า
        self.serverErrorMessage = nil 
        self.isEmailValid = true
        
        // MARK: - 3. เรียก API (Simulation)
        
        // ในโลกจริง: คุณจะเรียก service.requestPasswordReset(email: self.email)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let currentEmail = self.email.lowercased()
            
            // **✅ กรณีที่ 1: ส่ง OTP สำเร็จ (เฉพาะ exam@gmail.com)**
            if currentEmail == "exam@gmail.com" {
                print("OTP request successful for: \(currentEmail)")
                completion(true)
                return
            }
            
            // **❌ กรณีที่ 2: อีเมลอื่น ๆ ทั้งหมดที่รูปแบบถูกต้อง**
            // จะถือว่าไม่ได้ลงทะเบียน และแสดงข้อความผิดพลาด
            self.isEmailValid = false
            self.serverErrorMessage = "อีเมลนี้ยังไม่ได้ลงทะเบียน"
            completion(false)
            return
        }
    }
}
