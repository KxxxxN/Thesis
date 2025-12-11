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
                        BackButton()
                        
                        Spacer()
                                                
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "" : "แก้ไข")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(isEditing ? Color.clear : Color.mainColor)
                                .padding(.horizontal,31)
                        }
                    }
                }
                
                Image("Profile")
                    .resizable()
                    .frame(width: 85,height: 85)
                    .clipShape(Circle())
                    .padding(.top,35)
                    .padding(.bottom,11)
                
                VStack(alignment: .leading, spacing: 10){
                    
                    // --- ชื่อ ---
                    VStack(alignment: .leading, spacing: 4){
                        Title(title: "ชื่อ")
                        
                        HStack {
                            if isEditing {

                                TextField("ป้อนชื่อของคุณ", text: $name)
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)

                            } else {
                                // โหมดดู: ใช้ Text ธรรมดา ผู้ใช้คลิกไม่ได้
                                Text(displayValue(for: name))
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                            }
                            
                            Spacer()
                            
                            if isEditing {
                                Button(action: {
                                    print("แก้ไขชื่อ")
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(Color.mainColor)
                                        .frame(width: 16, height: 18)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    }
                    
                    // --- นามสกุล ---
                    VStack(alignment: .leading, spacing: 4){
                        Title(title: "นามสกุล")
                        
                        HStack {
                            if isEditing {
                                // โหมดแก้ไข: ใช้ TextField
                                TextField("ป้อนชื่อของคุณ", text: $lastName)
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)

                            } else {
                                // โหมดดู: ใช้ Text ธรรมดา ผู้ใช้คลิกไม่ได้
                                Text(displayValue(for: lastName))
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                            }
                            
                            Spacer()
                            
                            if isEditing {
                                Button(action: {
                                    print("แก้ไขนามสกุล")
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(Color.mainColor)
                                        .frame(width: 16, height: 18)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    }
                    
                    // --- อีเมล ---
                    VStack(alignment: .leading, spacing: 4){
                        Title(title: "อีเมล")
                                                
                        Group {
                            if isEditing {
                                // MARK: - โหมดแก้ไข (ใช้ NavigationLink)
                                NavigationLink(destination: ConfirmPasswordView()) {
                                    HStack {
                                        Text(displayValue(for: email)) // แสดงค่า
                                            .font(.noto(20, weight: .medium))
                                            .foregroundColor(Color.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "pencil") // ไอคอนดินสอ
                                            .foregroundColor(Color.mainColor)
                                            .frame(width: 16, height: 18)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            } else {
                                // MARK: - โหมดดู (ไม่ใช่ Button)
                                HStack {
                                    Text(displayValue(for: email))
                                        .font(.noto(20, weight: .medium))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    }
                    
                    // --- เบอร์โทร ---
                    VStack(alignment: .leading, spacing: 4){
                        Title(title: "เบอร์โทร")
                                                
                        Group {
                            if isEditing {
                                // MARK: - โหมดแก้ไข (ใช้ NavigationLink)
                                NavigationLink(destination: ConfirmPasswordView()) {
                                    HStack {
                                        Text(displayValue(for: phoneNumber)) // แสดงค่า
                                            .font(.noto(20, weight: .medium))
                                            .foregroundColor(Color.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "pencil") // ไอคอนดินสอ
                                            .foregroundColor(Color.mainColor)
                                            .frame(width: 16, height: 18)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            } else {
                                // MARK: - โหมดดู (ไม่ใช่ Button)
                                HStack {
                                    Text(displayValue(for: phoneNumber))
                                        .font(.noto(20, weight: .medium))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    }
                    
                    // --- รหัสผ่าน ---
                    VStack(alignment: .leading, spacing: 4){
                        Title(title: "รหัสผ่าน")
                                                
                        Group {
                            let passwordDisplay: String = isPasswordVisible ? password : displayValue(for: "hasValue", isSecure: true)
                            if isEditing {
                                // MARK: - โหมดแก้ไข (ใช้ NavigationLink)
                                NavigationLink(destination: ConfirmEmailView()) {
                                    HStack {
                                        Text(passwordDisplay) // แสดงค่า
                                            .font(.noto(20, weight: .medium))
                                            .foregroundColor(Color.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "pencil") // ไอคอนดินสอ
                                            .foregroundColor(Color.mainColor)
                                            .frame(width: 16, height: 18)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            } else {
                                // MARK: - โหมดดู (ไม่ใช่ Button)
                                HStack {
                                    Text(passwordDisplay)
                                        .font(.noto(20, weight: .medium))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                            .foregroundColor(Color.mainColor)
                                    }

                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        .frame(width: 345, height: 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    }
                    
                }
                Spacer()
                if isEditing{
                    HStack(alignment: .bottom,spacing: 35){
                        SecondButton(
                            title: "ยกเลิก",
                            action: {
                                print("ยกเลิก")
//                                withAnimation {
                                    isEditing.toggle()
                                // TODO: Logic สำหรับยกเลิกการแก้ไข (เช่น รีเซ็ตค่า)
//                                }
                            },
                            width: 155,
                            height: 49
                        )
                        PrimaryButton(
                            title: "บันทึก",
                            action:{
//                                withAnimation {
                                    isEditing.toggle()
                                    print("บันทึก")
                                // TODO: Logic สำหรับบันทึกข้อมูล
//                                }
                            },
                            width: 155,
                            height: 49
                        )
                    }
                    .padding(.bottom,20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ProfileView()
}
