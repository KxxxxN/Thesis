//
//  ProfileView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ProfileView: View {
    @State private var name: String
    @State private var lastName: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var password: String
    
    @State private var isEditing: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    
    @State private var navigateToConfirmPassword: Bool = false
    
    @State private var isNameInvalid: Bool = false
    @State private var isLastNameInvalid: Bool = false
    @State private var isPhoneInvalid: Bool = false
        
    // เก็บค่าสำรองไว้ใช้กรณี "ยกเลิก"
    @State private var originalName: String = ""
    @State private var originalLastName: String = ""
    @State private var originalPhone: String = ""
    
    private func resetData() {
        name = originalName
        lastName = originalLastName
        phoneNumber = originalPhone
        
        // ล้างสถานะ Error ด้วย
        isNameInvalid = false
        isLastNameInvalid = false
        isPhoneInvalid = false
    }
    
    init(
        initialName: String = "สุนิสา",
        initialLastName: String = "จินดาวัฒนา",
        initialEmail: String = "sunisa.jindawan@gmail.com",
        initialPhoneNumber: String = "0832634573",
        initialPassword: String = "12345678")
    {
        _name = State(initialValue: initialName)
        _lastName = State(initialValue: initialLastName)
        _email = State(initialValue: initialEmail)
        _phoneNumber = State(initialValue: initialPhoneNumber)
        _password = State(initialValue: initialPassword)
    }
    
    private func displayValue(for value: String, isSecure: Bool = false) -> String {
        if value.isEmpty {
            return "ไม่ได้ระบุ"
        }
        if isSecure {
            return String(repeating: "•", count: password.count)
        }
        return value
    }
            
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("แก้ไขโปรไฟล์")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    HStack {
                        Button(action: {
                            resetData() // คืนค่าก่อนย้อนกลับ
                            // ใส่ Logic ย้อนกลับของคุณที่นี่ เช่น dismiss()
                        }) {
                            BackButton()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // เก็บค่าปัจจุบันไว้เป็นค่าสำรองก่อนเริ่มแก้ไข
                            if !isEditing {
                                originalName = name
                                originalLastName = lastName
                                originalPhone = phoneNumber
                            }
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "" : "แก้ไข")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(isEditing ? Color.clear : Color.mainColor)
                                .padding(.horizontal, 31)
                        }
                    }
                }
                
                Image("Profile")
                    .resizable()
                    .frame(width: 85,height: 85)
                    .clipShape(Circle())
                    .padding(.top,35)
                    .padding(.bottom,11)
                
                VStack(alignment: .leading, spacing: 0){
                    
                    // --- ชื่อ ---
                    ProfileInputField(
                        title: "ชื่อ",
                        placeholder: "ป้อนชื่อของคุณ",
                        text: $name,
                        isEditing: $isEditing,
                        isInvalid: $isNameInvalid,
                        errorMessage: "รูปแบบชื่อไม่ถูกต้อง",
                        onEditingChanged: {
                            isNameInvalid = !ValidationHelper.isNameValid(name: name)
                        }
                    )
                    
                    // --- นามสกุล ---
                    ProfileInputField(
                        title: "นามสกุล",
                        placeholder: "ป้อนนามสกุลของคุณ",
                        text: $lastName,
                        isEditing: $isEditing,
                        isInvalid: $isLastNameInvalid,
                        errorMessage: "รูปแบบนามสกุลไม่ถูกต้อง",
                        onEditingChanged: {
                            isLastNameInvalid = !ValidationHelper.isNameValid(name: lastName)
                        }
                    )
                    
                    // --- อีเมล ---
                    ProfileEmailField(
                        title: "อีเมล",
                        email: email,
                        isEditing: $isEditing
                    )
                    
                    // --- เบอร์โทร ---
                    ProfileInputField(
                        title: "เบอร์โทร",
                        placeholder: "0XX-XXX-XXXX",
                        text: $phoneNumber,
                        isEditing: $isEditing,
                        isInvalid: $isPhoneInvalid,
                        errorMessage: "รูปแบบเบอร์โทรไม่ถูกต้อง",
                        keyboardType: .numberPad,
                        onEditingChanged: {
                            isPhoneInvalid = !ValidationHelper.isValidPhone(phoneNumber)
                        }
                    )
                    
                    // --- รหัสผ่าน ---
                    
                    ProfilePasswordField(
                        title: "รหัสผ่าน",
                        password: password,
                        isEditing: $isEditing,
                        isPasswordVisible: $isPasswordVisible
                    )
                }
                
                Spacer()
                
                if isEditing{
                    HStack(alignment: .bottom,spacing: 35){
                        SecondButton(
                            title: "ยกเลิก",
                            action: {
                                resetData() // คืนค่าเก่ากลับมา
                                isEditing = false
                            },
                            width: 155,
                            height: 49
                        )
                        
                        PrimaryButton(
                            title: "บันทึก",
                            action: {
                                // ถ้าผ่าน Validation ทั้งหมด
                                if !isNameInvalid && !isLastNameInvalid && !isPhoneInvalid &&
                                    !name.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty {
                                    
                                    // อัปเดตค่าสำรองให้เป็นค่าใหม่ที่บันทึก
                                    originalName = name
                                    originalLastName = lastName
                                    originalPhone = phoneNumber
                                    
                                    isEditing = false
                                    print("บันทึกสำเร็จ")
                                }
                            },
                            width: 155,
                            height: 49
                        )
                        .disabled(isNameInvalid || isLastNameInvalid || isPhoneInvalid ||
                                  name.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)
                        .opacity((isNameInvalid || isLastNameInvalid || isPhoneInvalid ||
                                  name.isEmpty || lastName.isEmpty || phoneNumber.isEmpty) ? 0.5 : 1)
                    }
                    .padding(.bottom,20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            // ตั้งค่าข้อมูลสำรองครั้งแรกเมื่อหน้าจอแสดงผล
            originalName = name
            originalLastName = lastName
            originalPhone = phoneNumber
        }
    }
}

#Preview {
    ProfileView()
}
