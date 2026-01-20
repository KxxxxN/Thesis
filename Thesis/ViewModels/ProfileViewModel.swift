//
//  ProfileViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 12/1/2569 BE.
//


import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var name: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    
    // MARK: - UI States
    @Published var isEditing: Bool = false
    @Published var isSubmitted: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    
    // MARK: - Validation States
    @Published var isNameInvalid: Bool = false
    @Published var isLastNameInvalid: Bool = false
    @Published var isPhoneInvalid: Bool = false
    
    // MARK: - Original Data (ใช้สำหรับยกเลิก)
    private var originalName: String = ""
    private var originalLastName: String = ""
    private var originalPhone: String = ""
    
    // MARK: - Initializer
    init(name: String, lastName: String, email: String, phone: String, password: String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phone
        self.password = password
        
        // บันทึกค่าเริ่มต้น
        self.saveOriginalData()
    }
    
    private func saveOriginalData() {
        originalName = name
        originalLastName = lastName
        originalPhone = phoneNumber
    }
    
    // MARK: - Functions
    
    func startEditing() {
        saveOriginalData()
        isEditing = true
        isSubmitted = false
    }
    
    func cancelEditing() {
        name = originalName
        lastName = originalLastName
        phoneNumber = originalPhone
        
        isNameInvalid = false
        isLastNameInvalid = false
        isPhoneInvalid = false
        isEditing = false
        isSubmitted = false
    }
    
    func clearError(for field: String) {
        switch field {
        case "name": isNameInvalid = false
        case "lastName": isLastNameInvalid = false
        case "phone": isPhoneInvalid = false
        default: break
        }
    }
    
    func validateForm() -> Bool {
        isNameInvalid = name.isEmpty || !ValidationHelper.isNameValid(name: name)
        isLastNameInvalid = lastName.isEmpty || !ValidationHelper.isNameValid(name: lastName)
        isPhoneInvalid = phoneNumber.isEmpty || !ValidationHelper.isValidPhone(phoneNumber)
        
        return !isNameInvalid && !isLastNameInvalid && !isPhoneInvalid
    }
    
    func saveProfile() {
        isSubmitted = true
        
        if validateForm() {
            // บันทึกค่าใหม่เป็นค่าต้นฉบับ
            saveOriginalData()
            
            withAnimation {
                showSuccessPopup = true
                isEditing = false
                isSubmitted = false
            }
            print("Profile updated successfully")
        } else {
            withAnimation {
                showErrorPopup = true
            }
        }
    }
}