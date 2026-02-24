//
//  AccountView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct AccountView: View {
    @State private var isNotificationOn = true
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
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
                            destination:
                                ProfileView()
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
                                destination: TranslateView()
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
                                destination: HelpCenterView()
                            )
                            
                            // Contact
                            AccountMenuRow(
                                title: "ติดต่อเรา",
                                imageName: "IconSupport",
                                destination: ContactUsView()
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
                                action: { isLoggedIn = false; print("Logout") }
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
        }
    }
}

#Preview {
    AccountView()
}
