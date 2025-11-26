//
//  RegisterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var isPrivacyAccepted: Bool = false
    @State private var showPrivacyPopup: Bool = false
    @State private var showSuccessPopup: Bool = false
    @State private var isFormSubmitted: Bool = false
    
    @State private var isFirstNameValid: Bool = true
    @State private var isLastNameValid: Bool = true
    @State private var isEmailValid: Bool = true
    @State private var isPhoneValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isConfirmPasswordValid: Bool = true
    
    private func isValidPhone(phone: String) -> Bool {
        // Regex สำหรับเบอร์มือถือไทย 10 หลัก (เริ่มต้นด้วย 0)
        // อนุญาตรูปแบบ 0XXXXXXXXX หรือ 0XX-XXX-XXXX
        let phoneRegex = "^(0[0-9]{2}-?)([0-9]{3}-?)([0-9]{4})$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func isValidEmail(email: String) -> Bool {
        // Regex สำหรับรูปแบบอีเมลพื้นฐาน (รองรับตัวอักษร, ตัวเลข, จุด, ขีดล่าง, ขีดกลาง, @, โดเมน)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isNameValid(name: String) -> Bool {
        // 1. อนุญาตให้ว่าง
        if name.isEmpty { return true }
        
        // 2. ตรวจสอบว่ามีแต่ภาษาไทยหรือไม่ (ก-ฮ, Space, Hyphen)
        // การแก้ไข: เปลี่ยนจาก ก-๙ เป็น ก-ฮ เพื่อไม่รวมตัวเลขไทย
        let thaiRegex = "^[\\p{Thai}\\s\\-]+$"
        let isThaiOnly = NSPredicate(format: "SELF MATCHES %@", thaiRegex).evaluate(with: name)
        
        // 3. ตรวจสอบว่ามีแต่ภาษาอังกฤษหรือไม่ (a-z, A-Z, Space, Hyphen)
        let englishRegex = "^[a-zA-Z\\s\\-]+$"
        let isEnglishOnly = NSPredicate(format: "SELF MATCHES %@", englishRegex).evaluate(with: name)
        
        // 4. ถ้าเป็นภาษาใดภาษาหนึ่งเท่านั้น ให้ถือว่าถูกต้อง
        return isThaiOnly || isEnglishOnly
    }
    
    private func isPasswordValid(password: String) -> Bool {
            let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%&*_-]).{8,}$"
            
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return passwordPredicate.evaluate(with: password)
        }
    
    private func requiredTitle(title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.noto(20, weight: .bold))
            Text(" *")
                .font(.noto(20, weight: .bold))
                .foregroundColor(.red) // Added red color for the asterisk
        }
    }
    
    private func validateForm() -> Bool {
        // ตรวจสอบว่าช่องว่างหรือไม่
        isFirstNameValid = !firstName.isEmpty
        isLastNameValid = !lastName.isEmpty
        isEmailValid = !email.isEmpty
        isPhoneValid = !phone.isEmpty
        isPasswordValid = !password.isEmpty
        isConfirmPasswordValid = !confirmPassword.isEmpty
        
        // MARK: - ตรวจสอบความถูกต้องของชื่อ/นามสกุล
            if isFirstNameValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
                isFirstNameValid = isNameValid(name: firstName)
            }
        if isLastNameValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isLastNameValid = isNameValid(name: lastName)
        }
        
        // MARK: - ตรวจสอบรหัสผ่านตามเงื่อนไขใหม่
        if !password.isEmpty {
            isPasswordValid = isPasswordValid(password: password)
        } else {
            isPasswordValid = false
        }
        // MARK: - ตรวจสอบว่ารหัสผ่านและยืนยันรหัสผ่านตรงกันหรือไม่
        if isPasswordValid && isConfirmPasswordValid && !password.isEmpty && !confirmPassword.isEmpty {
            if password != confirmPassword {
                isPasswordValid = false // ตั้งให้ช่อง Password เป็น Invalid ด้วย
                isConfirmPasswordValid = false
            } else {
                // ถ้าตรงกัน ให้ตั้งเป็น true อีกครั้งหากก่อนหน้านี้ถูกตั้งเป็น false
                isConfirmPasswordValid = true
            }
        }
        
        // MARK: - ตรวจสอบรูปแบบอีเมล
        if isEmailValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isEmailValid = isValidEmail(email: email)
        }
        
        // MARK: - ตรวจสอบรูปแบบเบอร์โทรศัพท์
        if isPhoneValid { // ถ้าไม่ว่าง ให้ตรวจสอบรูปแบบ
            isPhoneValid = isValidPhone(phone: phone)
        }
        
        // คืนค่า true ถ้าทุกช่องถูกต้อง
        return isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid && isPrivacyAccepted
    }
    
    struct ValidationBorder: ViewModifier {
        let isValid: Bool
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isValid ? Color.clear : Color.errorColor, lineWidth: isValid ? 0 : 2) // เปลี่ยนเป็น .clear ถ้าถูกต้อง
                )
        }
    }
    
    private func placeholderView(text: String, placeholder: String) -> some View {
        HStack {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.placeholderColor)
                    .font(.noto(18 , weight: .medium))
            }
            Spacer()
        }
    }
    
    // MARK: - Password Validation Logic
        private func hasMinimumLength(_ password: String) -> Bool {
            return password.count >= 8
        }

        private func hasUppercase(_ password: String) -> Bool {
            let regex = ".*[A-Z]+.*"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }

        private func hasLowercase(_ password: String) -> Bool {
            let regex = ".*[a-z]+.*"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }

        private func hasDigit(_ password: String) -> Bool {
            let regex = ".*[0-9]+.*"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }

        private func hasSpecialCharacter(_ password: String) -> Bool {
            // อักขระพิเศษ: !@#$%&*_-
            let regex = ".*[!@#$%&*_-]+.*"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
        }
    
    // MARK: - Password Validation View (Checklist)
    private func PasswordValidationView() -> some View {
        let checkColor: Color = Color.mainColor
        let defaultColor: Color = Color.placeholderColor
        return VStack(alignment: .leading, spacing: 3) {
            Group {
                // เงื่อนไขที่ 1: ความยาว 8 ตัวอักษร
                HStack(spacing: 4) {
                    // *** แก้ไขไอคอนเป็น "circle" เพื่อให้ชัดเจน ***
                    let passed = hasMinimumLength(password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("อย่างน้อย 8 ตัวอักษร")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                // เงื่อนไขที่ 2: ตัวอักษรพิมพ์ใหญ่
                HStack(spacing: 4) {
                    let passed = hasUppercase(password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวอักษรพิมพ์ใหญ่ อย่างน้อย 1 ตัว (A–Z)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                // เงื่อนไขที่ 3: ตัวอักษรพิมพ์เล็ก
                HStack(spacing: 4) {
                    let passed = hasLowercase(password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวอักษรพิมพ์เล็ก อย่างน้อย 1 ตัว (a–z)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                // เงื่อนไขที่ 4: ตัวเลข
                HStack(spacing: 4) {
                    let passed = hasDigit(password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีตัวเลข อย่างน้อย 1 ตัว (0–9)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
                // เงื่อนไขที่ 5: อักขระพิเศษ
                HStack(spacing: 4) {
                    let passed = hasSpecialCharacter(password)
                    Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passed ? checkColor : defaultColor)
                    Text("มีอักขระพิเศษ อย่างน้อย 1 ตัว (!@#$%&*_- เป็นต้น)")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(passed ? checkColor : defaultColor)
                }
            }
            .font(.noto(14, weight: .medium))
        }
        .frame(width: 345, alignment: .leading)
    }
    
    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isValid: Binding<Bool>,
        errorMessage: String = "จำเป็นต้องระบุ",
        isSecure: Bool = false,
        isPasswordToggle: Binding<Bool>? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            requiredTitle(title: title)
                
            HStack {
                ZStack(alignment: .leading) {
                    placeholderView(text: text.wrappedValue, placeholder: placeholder) // วาง Placeholder ด้านล่าง
                    
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("", text: text)
                        } else {
                            TextField("", text: text)
                        }
                    } else {
                        TextField("", text: text)
                    }
                }
                    
                // ปุ่มแสดง/ซ่อนรหัสผ่าน
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle() } label: {
                        Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            // แสดงขอบสีแดงเมื่อ !isValid (เมื่อช่องว่าง)
            .modifier(ValidationBorder(isValid: isValid.wrappedValue))
                
            // MARK: - การแก้ไข: ข้อความแสดงข้อผิดพลาดแบบไม่จองพื้นที่
            // จะแสดงเมื่อ !isValid (โดย !isValid จะเป็นจริงเมื่อช่องว่างตาม logic ใน validateForm)
            Group {
                Text(errorMessage)
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(Color.errorColor)
            }
            .frame(height: !isValid.wrappedValue ? 20 : 0, alignment: .top)
            .clipped() // ป้องกันข้อความล้น
        }
    }
    
    var body: some View {
//        @State var isFormSubmitted: Bool = false
        NavigationStack {
            ZStack {
                VStack{ //เปิด Vstack1
                    ZStack {
                        Text("ลงทะเบียน")
                            .font(.noto(25, weight: .bold))
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.leading, 18)
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                    
                    // MARK: Form Fields
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{ //เปิด Vstack2
                            
                            // First Name
                            inputField(
                                    title: "ชื่อ",
                                    placeholder: "กรอกชื่อภาษาไทย",
                                    text: $firstName,
                                    isValid: $isFirstNameValid,
                                    // MARK: - แก้ไข: ข้อความ Error สำหรับชื่อ
                                    errorMessage: firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง" // เปลี่ยนข้อความที่นี่
                                )
                            .onChange(of: firstName) { // ไม่มี 'in'
                                    // Live validation: ถ้าช่องไม่ว่าง ให้ตรวจสอบรูปแบบชื่อ
                                    if !firstName.isEmpty {
                                        isFirstNameValid = isNameValid(name: firstName)
                                    }
                                }
                            
                            // Last Name
                            inputField(
                                    title: "นามสกุล",
                                    placeholder: "กรอกนามสกุลภาษาไทย",
                                    text: $lastName,
                                    isValid: $isLastNameValid,
                                    // MARK: - แก้ไข: ข้อความ Error สำหรับนามสกุล
                                    errorMessage: lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง" // เปลี่ยนข้อความที่นี่
                                )
                            .onChange(of: lastName) {
                                    if !lastName.isEmpty {
                                        isLastNameValid = isNameValid(name: lastName)
                                    }
                                }
                            
                            // Email
                            inputField(
                                title: "อีเมล",
                                placeholder: "กรอกอีเมล",
                                text: $email,
                                isValid: $isEmailValid,
                                // MARK: - กำหนด Error Message สำหรับอีเมล
                                errorMessage: email.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบอีเมลไม่ถูกต้อง"
                            )
                            // MARK: - เพิ่ม Live Validation สำหรับ Email
                            .onChange(of: email) {
                                // Live validation: ถ้าช่องไม่ว่าง ให้ตรวจสอบรูปแบบอีเมล
                                if !email.isEmpty {
                                    isEmailValid = isValidEmail(email: email)
                                }
                            }
                            
                            // Phone
                            inputField(
                                title: "เบอร์โทร",
                                placeholder: "0XX-XXX-XXXX",
                                text: $phone,
                                isValid: $isPhoneValid,
                                // MARK: - กำหนด Error Message สำหรับเบอร์โทรศัพท์
                                errorMessage: phone.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบเบอร์โทรไม่ถูกต้อง"
                            )
                            // MARK: - เพิ่ม Live Validation สำหรับ Phone
                            .onChange(of: phone) {
                                // Live validation: ถ้าช่องไม่ว่าง ให้ตรวจสอบรูปแบบเบอร์โทรศัพท์
                                if !phone.isEmpty {
                                    isPhoneValid = isValidPhone(phone: phone)
                                }
                            }
                            
                            // Password
                            inputField(
                                title: "รหัสผ่าน",
                                placeholder: "อย่างน้อย 8 ตัวอักษร",
                                text: $password,
                                isValid: $isPasswordValid,
                                // MARK: - กำหนด Error Message สำหรับรหัสผ่าน
                                errorMessage: password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง",
                                isSecure: true,
                                isPasswordToggle: $isPasswordVisible
                            )
                            .onChange(of: password) {
                                // Live validation:
                                if !password.isEmpty {
                                    // ตรวจสอบเงื่อนไขตาม Regex
                                    let regexPassed = isPasswordValid(password: password)
                                    // ตรวจสอบว่าตรงกับ Confirm Password หรือไม่
                                    let matchConfirmed = (password == confirmPassword)

                                    // isPasswordValid จะเป็น false ถ้า Regex ไม่ผ่าน หรือ ถ้าไม่ตรงกับ Confirm Password
                                    isPasswordValid = regexPassed && (confirmPassword.isEmpty || matchConfirmed)
                                    
                                    // อัปเดตสถานะของ Confirm Password ด้วย
                                    if !confirmPassword.isEmpty {
                                        isConfirmPasswordValid = matchConfirmed
                                    }
                                }
                            }
                            
                            if !isPasswordValid(password: password) {
                                PasswordValidationView()
                                    .padding(.top, -7)
                                    .padding(.bottom, 5)
                            }
                            
                            // Confirm Password
                            inputField(
                                title: "ยืนยันรหัสผ่าน",
                                placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                text: $confirmPassword,
                                isValid: $isConfirmPasswordValid,
                                // MARK: - กำหนด Error Message สำหรับยืนยันรหัสผ่าน
                                errorMessage: confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน",
                                isSecure: true,
                                isPasswordToggle: $isConfirmPasswordVisible
                            )
                            .onChange(of: confirmPassword) {
                                // Live validation:
                                if !confirmPassword.isEmpty {
                                    // isConfirmPasswordValid จะเป็น false ถ้าไม่ตรงกัน
                                    isConfirmPasswordValid = (password == confirmPassword)
                                }
                            }
                            
                        }//ปิด Vstack2
                        .padding(.horizontal, 40)
                        
                        // MARK: Privacy Accept
                        VStack {
                            HStack {
                                Button { isPrivacyAccepted.toggle() } label: {
                                    Image(systemName: isPrivacyAccepted ? "checkmark.square.fill" : "square")
                                        .foregroundColor(isPrivacyAccepted ? .mainColor : .mainColor)
                                        .font(.system(size: 20))
                                }
                                HStack(spacing:0){
                                    Text("ฉันได้อ่านและยอมรับ")
                                        .font(.noto(15, weight: .medium))
                                    
                                    Button(action: { showPrivacyPopup = true }){
                                        Text("นโยบายความเป็นส่วนตัว*")
                                            .font(.noto(15,weight: .semibold))
                                            .foregroundColor(Color.dangerColor)
                                            .underline(color: .dangerColor)
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: 345, alignment: .leading)
                            
                            if !isPrivacyAccepted && isFormSubmitted {
                                Text("จำเป็นต้องยอมรับนโยบายความเป็นส่วนตัว")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(Color.errorColor)
                                    .frame(width: 345, alignment: .leading)
                            }
                        }
                        .padding(.top,16)
                        
                        Button(action: {
                            isFormSubmitted = true
                            if validateForm() {
                                print("สร้างบัญชีสำเร็จ")
                                showSuccessPopup = true
                                // isLoggedIn = true
                                Task {
                                    try await Task.sleep(nanoseconds: 2_000_000_000)
                                    
                                    // ตรวจสอบว่า Popup ยังเปิดอยู่หรือไม่ก่อนทำการปิด
                                    if showSuccessPopup {
                                        showSuccessPopup = false // ปิด Popup
                                        dismiss()
                                    }
                                }
                            } else {
                                print("มีช่องที่ต้องกรอก")
                            }
                        }) {
                            Text("สร้างบัญชี")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 155, height: 49)
                                .background(Color.mainColor)
                                .cornerRadius(20)
                        }
                        .padding(.top, 13)
                        .padding(.bottom, 20)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .blur(radius: showPrivacyPopup ? 6 : 0)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                // MARK: Privacy Popup
                if showPrivacyPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { showPrivacyPopup = false }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        }
                                        
                        ScrollView {
                            Text("""
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                            """)
                            .font(.noto(16))
                            .padding()
                        }
                        .frame(height: 500)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(15)
                    }
                    .padding()
                    .frame(width: 386)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.scale)
                    .animation(.spring(), value: showPrivacyPopup)
                }
                
                // MARK: - Success Popup
                if showSuccessPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        
                    VStack {
                        VStack(spacing: 29) {
                            Image("Passmark")
                                .resizable()
                                .frame(width: 111, height: 111)
                            
                            Text("สร้างบัญชีสำเร็จ")
                                .font(.noto(25, weight: .bold))
                                .foregroundColor(.black)

                            // MARK: - ลบปุ่ม 'ตกลง' ออก
                        }
                        .padding(40) // เพิ่ม Padding ภายในแทน
                        .frame(width: 343, height: 255) // ปรับขนาดให้เล็กลง
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .transition(.scale)
                        .animation(.spring(), value: showSuccessPopup)
                        
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}

#Preview {
    RegisterView()
}
