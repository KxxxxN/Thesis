//
//  AccountView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

enum AccountDestination: Hashable {
    case profile
    case translate
    case helpCenter
    case contactUs
    case confirmPassword
    case confirmEmail(String)
//    case newPassword
//    case confirmEmail(String)
//    case otp(String)
}

struct AccountView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isNotificationOn = true
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                Spacer()
                
                Text("บัญชีผู้ใช้")
                    .font(.noto(25, weight: .bold))
                    .padding(.bottom, 28)
                
                VStack(spacing: 22) {
                    
                    // --- กลุ่ม: ข้อมูลผู้ใช้ ---
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ข้อมูลผู้ใช้")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 20)
                        
                        //Profile
                        AccountMenuRow(
                            title: "แก้ไขโปรไฟล์",
                            imageName: "IconUser",
                            action: { path.append(AccountDestination.profile) }
                        )
                    }
                    
                    // --- กลุ่ม: ตั้งค่า ---
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ตั้งค่า")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            //Translate
                            AccountMenuRow(
                                title: "เปลี่ยนภาษา",
                                imageName: "IconTranslate",
                                action: { path.append(AccountDestination.translate) }
                            )
                            
                            //Notification
                            AccountToggleRow(
                                title: "การแจ้งเตือน",
                                imageName: "IconNotification",
                                isOn: $isNotificationOn
                            )
                        }
                    }
                    
                    // --- กลุ่ม: ทั่วไป ---
                    VStack(alignment: .leading, spacing: 7) {
                        Text("ทั่วไป")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            // Help Center
                            AccountMenuRow(
                                title: "ช่วยเหลือ",
                                imageName: "IconHelp",
                                action: { path.append(AccountDestination.helpCenter) }
                            )
                            
                            // Contact
                            AccountMenuRow(
                                title: "ติดต่อเรา",
                                imageName: "IconSupport",
                                action: { path.append(AccountDestination.contactUs) }
                            )
                        }
                    }
                    
                    // --- กลุ่ม: บัญชี ---
                    VStack(alignment: .leading, spacing: 7) {
                        Text("บัญชี")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(Color.clear)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            // ออกจากระบบ (Button)
                            AccountMenuRow(
                                title: "ออกจากระบบ",
                                imageName: "IconLogout",
                                action: {
                                    Task {
                                        await authViewModel.signOut()
                                        isLoggedIn = false
                                    }
                                }
                            )
                            
                            // ลบบัญชี (Button)
                            AccountMenuRow(
                                title: "ลบบัญชี",
                                imageName: "IconDelete",
                                action: { print("Delete Account") }
                            )
                        }
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await authViewModel.getInitialSession()
                }
            }
            .navigationDestination(for: AccountDestination.self) { destination in
                switch destination {
                case .profile:      ProfileView()
                case .translate:    TranslateView()
                case .helpCenter:   HelpCenterView()
                case .contactUs:    ContactUsView()
                case .confirmPassword:
                    ConfirmPasswordView()
                case .confirmEmail(let email):
                    ConfirmEmailView(currentEmail: email)
//                case .newPassword: NewPasswordView()
//                case .confirmEmail(let email):  ConfirmEmailView(currentEmail: email) 
//                case .otp(let email):           OTPConfirmView(source: .confirmEmail, email: email)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .popToAccount)) { _ in
            path = NavigationPath()
        }
//        .onReceive(NotificationCenter.default.publisher(for: .navigateToNewPassword)) { _ in
//            path.append(AccountDestination.newPassword)
//        }
//        .onReceive(NotificationCenter.default.publisher(for: .navigateToConfirmEmail)) { notification in
//            if let email = notification.object as? String {
//                path.append(AccountDestination.confirmEmail(email))
//            }
//        }
//        .onReceive(NotificationCenter.default.publisher(for: .navigateToNewPassword)) { _ in
//            withAnimation {
//                path.append(AccountDestination.newPassword)
//            }
//        }
//        .onReceive(NotificationCenter.default.publisher(for: .navigateToNewPassword)) { _ in
//            path.append(AccountDestination.newPassword)  // ไม่ต้อง withAnimation
//        }

        .onReceive(NotificationCenter.default.publisher(for: .popToProfile)) { _ in
            while path.count > 1 {
                path.removeLast()
            }
        }
    }
}

#Preview {
    AccountView()
}


