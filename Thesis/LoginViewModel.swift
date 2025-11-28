//
//  LoginViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


// LoginViewModel.swift

import Foundation
import SwiftUI
import Combine // ใช้สำหรับอนาคตหากต้องการจัดการ asynchronous

// 1. ทำให้เป็น ObservableObject เพื่อให้ View สามารถติดตามการเปลี่ยนแปลงได้
class LoginViewModel: ObservableObject {
    
    // MARK: - State Properties (สถานะของ View)
    
    // 2. ใช้ @Published เพื่อแจ้งเตือนการเปลี่ยนแปลงไปยัง View
    @Published var username: String = ""
    @Published var password: String = ""
    
    // สถานะ UI
    @Published var isPasswordVisible: Bool = false
    
    // สถานะ Error (สำหรับ Field-level validation: ตรวจสอบว่าช่องว่างหรือไม่)
    @Published var isUsernameEmpty: Bool = false
    @Published var isPasswordEmpty: Bool = false
    
    // สถานะ Error (สำหรับ Server/Logic Error: เช่น อีเมลหรือรหัสผ่านไม่ถูกต้อง)
    @Published var loginErrorMessage: String? = nil // ใช้ Optional เพื่อบ่งชี้ว่ามีข้อความผิดพลาดหรือไม่
    
    // AppStorage (ควรอยู่ใน Model หรือ Service แต่เพื่อความง่ายในการทดสอบสามารถเก็บไว้ที่นี่ได้)
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // MARK: - Computed Properties (คุณสมบัติที่คำนวณ)
    
    // ตรวจสอบว่ามีข้อผิดพลาดใด ๆ ที่ต้องแสดงเป็นกรอบสีแดงหรือไม่
    var isAnyError: Bool {
        return isUsernameEmpty || isPasswordEmpty || loginErrorMessage != nil
    }
    
    // ตรวจสอบว่าปุ่ม Login ควรถูกเปิดใช้งานหรือไม่
    var canLogin: Bool {
        return !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }
    
    // MARK: - Functions (ตรรกะการทำงาน)
    
    func login() {
        // 1. ล้างสถานะข้อความผิดพลาดก่อนเริ่ม
        loginErrorMessage = nil
        isUsernameEmpty = false
        isPasswordEmpty = false
        
        // 2. Client-side Validation: ตรวจสอบช่องว่าง
        isUsernameEmpty = username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        isPasswordEmpty = password.isEmpty
        
        // หากมีช่องใดช่องหนึ่งว่าง ให้หยุดและรอให้ View แสดงข้อความ "กรุณากรอก..."
        if isUsernameEmpty || isPasswordEmpty {
            print("Validation Failed: Empty fields")
            return
        }
        
        // 3. Server/Logic Simulation: การจำลองการเข้าสู่ระบบ
        
        // ** (ในแอปจริง ส่วนนี้คือโค้ดที่จะเรียก API หรือ Database เพื่อตรวจสอบข้อมูล) **
        let validUsername = "user@example.com"
        let validPassword = "12345678"
        
        if username == validUsername && password == validPassword {
            // Login สำเร็จ
            isLoggedIn = true
            print("Login Successful")
            // สามารถเพิ่มโค้ดสำหรับบันทึก User Session หรือ Token ได้ที่นี่
        } else {
            // Login ล้มเหลว - แสดงข้อความอีเมลหรือรหัสผ่านไม่ถูกต้อง
            loginErrorMessage = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
            
            // **การแสดงกรอบสีแดงพร้อมกัน:**
            // หากเกิดข้อผิดพลาดจาก Server/Logic (เช่น รหัสผ่านผิด) เราจะตั้งค่า
            // isUsernameEmpty และ isPasswordEmpty เป็น true ด้วย เพื่อให้กรอบสีแดงแสดง
            // ที่ TextFields ทั้งสองพร้อมกันตามความต้องการเดิม
            isUsernameEmpty = true
            isPasswordEmpty = true
            
            print("Login Failed: Incorrect credentials")
        }
    }
    
    // 💡 เคล็ดลับ: ควรมีฟังก์ชันสำหรับตรวจสอบอีเมลที่ซับซ้อนกว่านี้ในแอปจริง
    // เช่น func isValidEmail(email: String) -> Bool { ... }
}