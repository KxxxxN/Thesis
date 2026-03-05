//
//  AuthViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 24/2/2569 BE.
//


import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated: Bool = false
    
//    func getInitialSession() async {
//        do {
//            let current = try await supabase.auth.session
//            self.session = current
//            self.isAuthenticated = current != nil
//        } catch {
//            print("No Active session: \(error.localizedDescription)")
//        }
//    }
    
    func getInitialSession() async {
        do {
            // ใน SDK บางเวอร์ชัน .session จะ throw error ถ้าไม่มี session
            let current = try await supabase.auth.session
            
            self.session = current
            self.isAuthenticated = true
            
        } catch {
            // ถ้าเข้ามาใน catch แสดงว่าไม่มี session หรือเกิดข้อผิดพลาด
            self.session = nil
            self.isAuthenticated = false
            print("No active session or error: \(error.localizedDescription)")
        }
    }
        
    func signUp(email:String,password:String) async {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            self.session = result.session
            self.isAuthenticated = self.session != nil
            print("Sign up Success!")
        } catch {
            print("Sign up Failed: \(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let result = try await supabase.auth.signIn(email: email, password: password)
            self.session = result
            self.isAuthenticated = self.session != nil
            print("Sign in Success!")
        } catch {
            print("Sign in Failed: \(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
        } catch {
            print("Sign out Failed: \(error.localizedDescription)")
        }
    }
}
