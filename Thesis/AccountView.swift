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
    
    // 1. ตรวจสอบ Size Class (Compact = iPhone ส่วนใหญ่, Regular = iPad หรือ iPhone แนวนอน)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geo in
                // 2. คำนวณค่าตัวแปรตามขนาดหน้าจอ
                let isIPad = horizontalSizeClass == .regular
                let screenWidth = geo.size.width
                let screenHeight = geo.size.height
                
                // ปรับขนาด Font และ Spacing ตามขนาดหน้าจอ
                let titleFontSize: CGFloat = isIPad ? 36 : 25
                let sectionFontSize: CGFloat = isIPad ? 20 : 16
                let groupSpacing: CGFloat = isIPad ? 30 : 22
                let topPadding: CGFloat = screenHeight * (isIPad ? 0.07 : 0.07)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Header Title
                        Text("บัญชีผู้ใช้")
                            .font(.noto(titleFontSize, weight: .bold))
                            .padding(.top, topPadding)
                            .padding(.bottom, isIPad ? 40 : 28)
                        
                        // Main Content Group
                        VStack(spacing: groupSpacing) {
                            
                            // --- กลุ่ม: ข้อมูลผู้ใช้ ---
                            menuSection(title: "ข้อมูลผู้ใช้", fontSize: sectionFontSize) {
                                AccountMenuRow(
                                    title: "แก้ไขโปรไฟล์",
                                    imageName: "IconUser",
                                    action: { path.append(AccountDestination.profile) }
                                )
                            }
                            
                            // --- กลุ่ม: ตั้งค่า ---
                            menuSection(title: "ตั้งค่า", fontSize: sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "เปลี่ยนภาษา",
                                        imageName: "IconTranslate",
                                        action: { path.append(AccountDestination.translate) }
                                    )
                                    AccountToggleRow(
                                        title: "การแจ้งเตือน",
                                        imageName: "IconNotification",
                                        isOn: $isNotificationOn
                                    )
                                }
                            }
                            
                            // --- กลุ่ม: ทั่วไป ---
                            menuSection(title: "ทั่วไป", fontSize: sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "ช่วยเหลือ",
                                        imageName: "IconHelp",
                                        action: { path.append(AccountDestination.helpCenter) }
                                    )
                                    AccountMenuRow(
                                        title: "ติดต่อเรา",
                                        imageName: "IconSupport",
                                        action: { path.append(AccountDestination.contactUs) }
                                    )
                                }
                            }
                            
                            // --- กลุ่ม: บัญชี ---
                            menuSection(title: "บัญชี", fontSize: sectionFontSize, titleColor: .clear) {
                                VStack(spacing: 0) {
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
                                    AccountMenuRow(
                                        title: "ลบบัญชี",
                                        imageName: "IconDelete",
                                        action: { print("Delete Account") }
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .frame(width: screenWidth) // ให้ VStack หลักกว้างเท่าหน้าจอเพื่อให้จัดกลางได้
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task { await authViewModel.getInitialSession() }
            }
            .navigationDestination(for: AccountDestination.self) { destination in
                switch destination {
                case .profile:        ProfileView()
                case .translate:      TranslateView()
                case .helpCenter:     HelpCenterView()
                case .contactUs:      ContactUsView()
                case .confirmPassword: ConfirmPasswordView()
                case .confirmEmail(let email): ConfirmEmailView(currentEmail: email)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .popToAccount)) { _ in
            path = NavigationPath()
        }
        .onReceive(NotificationCenter.default.publisher(for: .popToProfile)) { _ in
            while path.count > 1 { path.removeLast() }
        }
    }

    // 3. Helper View สำหรับสร้าง Section เพื่อให้โค้ดสะอาดและ Responsive
    @ViewBuilder
    private func menuSection<Content: View>(
        title: String,
        fontSize: CGFloat,
        titleColor: Color = .black,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.noto(fontSize, weight: .bold))
                .foregroundColor(titleColor)
                .padding(.horizontal, 20)
            
            content()
        }
    }
}
#Preview {
    AccountView()
}

