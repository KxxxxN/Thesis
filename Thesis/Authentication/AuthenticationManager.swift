//
//  AuthenticationManager.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/1/2569 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDateResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user:User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {  }
    
    private let db = Firestore.firestore()
    
    // MARK: - Auth Methods
    func getAuthenticatedUser() throws -> AuthDateResultModel? {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDateResultModel(user: user)
    }
    
    // MARK: - Register
    @discardableResult
    func createUser(email:String, password:String) async throws -> AuthDateResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDateResultModel(user: authDataResult.user)
        
    }
    
    // MARK: - Login
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDateResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDateResultModel(user: authDataResult.user)
    }
    
    // MARK: - logout
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
    func updatePassword(password:String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func sendPasswordReset(email: String) async throws {
        // ใช้ Firebase Auth ส่งอีเมลรีเซ็ตรหัสผ่าน
        try await Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
    }
    
//    func changePassword(email: String, newPassword: String) async throws {
//        let db = Firestore.firestore()
//        let snapshot = try await db.collection("users")
//            .whereField("email", isEqualTo: email.lowercased()) // 1. หาว่า Document ไหนที่มี email นี้
//            .getDocuments()
//        
//        if let document = snapshot.documents.first {
//            // 2. ถ้าเจอ ให้ Update ไปที่ Document ID นั้น (ซึ่งอาจจะเป็น UID)
//            try await document.reference.updateData([
//                "password": newPassword
//            ])
//            print("DEBUG: อัปเดตรหัสผ่านสำเร็จใน Document: \(document.documentID)")
//        } else {
//            // 3. ถ้าหาไม่เจอจริงๆ (แสดงว่าไม่มี User นี้ในระบบ) ให้โยน Error
//            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "ไม่พบข้อมูลผู้ใช้ในระบบ"])
//        }
//    }
    
//    func updateEmail(email:String) async throws {
//        guard let user = Auth.auth().currentUser else {
//            throw URLError(.badServerResponse)
//        }
//        
//        try await user.updateEmail(to: email)
//    }
    
    // MARK: - Custom OTP System
    // 1. ฟังก์ชันสร้าง OTP และส่งอีเมลจริง
    func sendCustomOTP(email: String) async throws -> String {
        guard !email.isEmpty else {
            throw NSError(domain: "AuthManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "อีเมลไม่ถูกต้อง"])
        }
        
        // 1. ตรวจสอบก่อนว่ามีอีเมลนี้ในคอลเลกชัน "users" หรือไม่
        let userQuery = try await db.collection("users")
            .whereField("email", isEqualTo: email.lowercased())
            .getDocuments()
        
        // 2. ถ้าไม่พบอีเมลในระบบ ให้โยน Error ออกไป
        guard !userQuery.documents.isEmpty else {
            throw NSError(domain: "AuthManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "ไม่พบอีเมลนี้ในระบบ"])
        }
        
        // 3. ถ้าพบอีเมล ถึงจะเริ่มกระบวนการสร้าง OTP
        let otp = String(format: "%06d", Int.random(in: 0...999999))
        let refCode = String((0..<6).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
        
        let data: [String: Any] = [
            "otp": otp,
            "refCode": refCode,
            "expiresAt": Date().addingTimeInterval(300)
        ]
        
        try await db.collection("otp_codes").document(email.lowercased()).setData(data)
        try await sendEmailViaEmailJS(email: email, otp: otp, refCode: refCode)
        
        return refCode
    }
    
    // 2. ฟังก์ชันตรวจสอบ OTP จาก Firestore
    func verifyCustomOTP(email: String, enteredOTP: String) async throws -> Bool {
        // ⚠️ ป้องกันแอปค้าง: เช็คก่อนว่า email ไม่เป็นค่าว่าง
        guard !email.isEmpty else {
            print("Error: Email is empty")
            return false
        }

        let doc = try await db.collection("otp_codes").document(email.lowercased()).getDocument()
        
        guard let data = doc.data(),
              let correctOTP = data["otp"] as? String,
              let expiresAt = data["expiresAt"] as? Timestamp else {
            return false
        }
        
        if enteredOTP == correctOTP && Date() < expiresAt.dateValue() {
            try? await db.collection("otp_codes").document(email.lowercased()).delete()
            return true
        }
        return false
    }
    
    // 3. ฟังก์ชันเชื่อมต่อ EmailJS API
    private func sendEmailViaEmailJS(email: String, otp: String, refCode: String) async throws {
        let serviceId = "service_dom3yur"
        let templateId = "template_inczidy"
        let publicKey = "PGaMZuG85Oogd_iv7"
        
        let parameters: [String: Any] = [
            "service_id": serviceId,
            "template_id": templateId,
            "user_id": publicKey,
            "template_params": [
                "to_email": email,
                "otp_code": otp,
                "ref_code": refCode
            ]
        ]
        
        guard let url = URL(string: "https://api.emailjs.com/api/v1.0/email/send") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let serverMessage = String(data: data, encoding: .utf8) {
            print("EmailJS Server Message: \(serverMessage)")
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
