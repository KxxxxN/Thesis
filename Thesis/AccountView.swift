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
        VStack(spacing: 0) {
            Spacer()
            
            Text("บัญชีผู้ใช้")
                .font(.noto(25, weight: .bold))
                .padding(.bottom, 28)

            VStack(spacing: 22) {
                //ข้อมูลผู้ใช้
                VStack(alignment: .leading, spacing: 7) {
                    
                    Text("ข้อมูลผู้ใช้")
                        .font(.noto(16, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.horizontal,20)
                    
                    Button(action: {
                        print("Profile")
                    }) {
                        HStack(spacing: 15) {
                            Image("IconUser")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.leading, 35)
                            
                            Text("แก้ไขโปรไฟล์")
                                .font(.noto(20, weight: .medium))
                                .foregroundColor(Color.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.trailing)
                        .frame(height: 70)
                        .background(Color.accountSecColor)
                    }
                }
                
                //ตั้งค่า
                VStack(alignment: .leading, spacing: 7) {
                    
                    Text("ตั้งค่า")
                        .font(.noto(16, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.horizontal,20)
                    
                    VStack(spacing: 0) {
                        NavigationLink(destination: TranslateView()) {
                            HStack(spacing: 15) {
                                Image("IconTranslate")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("เปลี่ยนภาษา")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                        
                        Button(action: {
                            print("Notification")
                        }) {
                            HStack(spacing: 15) {
                                Image("IconNotification")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("การแจ้งเตือน")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                Toggle("", isOn: $isNotificationOn)
                                    .labelsHidden()
                                    .tint(.mainColor)
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                    }
                }

                //ทั่วไป
                VStack(alignment: .leading, spacing: 7) {
                    
                    Text("ทั่วไป")
                        .font(.noto(16, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.horizontal,20)
                    
                    VStack(spacing: 0) {
                        
                        Button(action: {
                            print("Heip Center")
                        }) {
                            HStack(spacing: 15) {
                                Image("IconHelp")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("ช่วยเหลือ")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                        
                        Button(action: {
                            print("Contact")
                        }) {
                            HStack(spacing: 15) {
                                Image("IconSupport")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("ติดต่อเรา")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 24, weight: .bold))
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                    }
                }
                
                //ทั่วไป
                VStack(alignment: .leading, spacing: 7) {
                    
                    Text("บัญชี")
                        .font(.noto(16, weight: .bold))
                        .foregroundColor(Color.clear)
                        .padding(.horizontal,20)
                    
                    VStack(spacing: 0) {
                        Button(action: {
                            isLoggedIn = false
                        }) {
                            HStack(spacing: 15) {
                                Image("IconLogout")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("ออกจากระบบ")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                        
                        Button(action: {
                            print("Delete Account")
                        }) {
                            HStack(spacing: 15) {
                                Image("IconDelete")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.leading, 35)
                                
                                Text("ลบบัญชี")
                                    .font(.noto(20, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Spacer()
                            }
                            .padding(.trailing)
                            .frame(height: 70)
                            .background(Color.accountSecColor)
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundColor)
    }
}

#Preview {
    AccountView()
}
