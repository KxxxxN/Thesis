//
//  ProfileView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI
import PhotosUI

@MainActor
struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var navigateToAccount = false
    @AppStorage("emailChangeSuccess") var emailChangeSuccess = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel())
    }
    
//    @MainActor
//    @ViewBuilder
//    private var profileImageView: some View {
//        ZStack {
//            if let image = viewModel.profileImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .frame(width: 85, height: 85)
//                    .clipShape(Circle())
//            } else {
//                Image("Profile")
//                    .resizable()
//                    .frame(width: 85, height: 85)
//                    .clipShape(Circle())
//            }
//            
//            if viewModel.isEditing {
//                Circle()
//                    .fill(Color.black.opacity(0.3))
//                    .frame(width: 85, height: 85)
//                
//                Image(systemName: "pencil")
//                    .foregroundColor(.white)
//                    .font(.system(size: 24))
//            }
//        }
//    }
    
    var body: some View {
        ZStack {
//            NavigationStack {
                VStack(spacing: 0) {
                    ZStack {
                        Text("แก้ไขโปรไฟล์")
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(Color.black)
                        
                        HStack {
                            BackButton(action: {
                                viewModel.cancelEditing()
                                NotificationCenter.default.post(name: .popToAccount, object: nil)
                            })
                            
                            Spacer()
                            
                            if !viewModel.isEditing {
                                Button(action: { viewModel.startEditing() }) {
                                    Text("แก้ไข")
                                        .font(.noto(16, weight: .medium))
                                        .foregroundColor(Color.mainColor)
                                        .padding(.horizontal, 31)
                                }
                            }
                        }
                    }
                    
//                    Image("Profile")
//                        .resizable()
//                        .frame(width: 85,height: 85)
//                        .clipShape(Circle())
//                        .padding(.top,35)
//                        .padding(.bottom,11).overlay(alignment: .bottomTrailing) {
//                            if viewModel.isEditing {
//                                Image(systemName: "pencil.circle.fill")
//                                    .font(.system(size: 26))
//                                    .foregroundColor(.mainColor)
//                                    .background(Color.white.clipShape(Circle()))
//                                    .offset(x: 4, y: -8)  // ปรับตำแหน่งให้พอดี
//                            }
//                        }
                    
                    let profileImage = viewModel.profileImage
                    let isEditing = viewModel.isEditing

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ZStack {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                            } else {
                                Image("Profile")
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                            }
                            
                            if isEditing {
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: 85, height: 85)
                                
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                    .frame(width: 85, height: 85)
                            }
                        }
                    }
                    
//                    PhotosPicker(selection: $selectedItem, matching: .images) {
//                        Group {
//                            if let image = profileImage {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .frame(width: 85, height: 85)
//                                    .clipShape(Circle())
//                            } else {
//                                Image("Profile")
//                                    .resizable()
//                                    .frame(width: 85, height: 85)
//                                    .clipShape(Circle())
//                            }
//                        }
//                        .overlay {
//                            if isEditing {
//                                Circle()
//                                    .fill(Color.black.opacity(0.3))
//                            }
//                        }
//                        .overlay(alignment: .bottomTrailing) {
//                            if isEditing {
//                                Image(systemName: "pencil")
//                                    .font(.system(size: 24))
//                                    .foregroundColor(.black)
//                                    .offset(x: 8, y: 5)
//                            }
//                        }
//                    }
                    
                    .padding(.top, 35)
                    .padding(.bottom, 11)
                    .disabled(!isEditing)  // ✅ ใช้ local variable แทน
                    .onChange(of: selectedItem) { _, newItem in
                        Task { @MainActor in  // ✅ เพิ่ม @MainActor
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                viewModel.profileImage = image
                                await viewModel.uploadProfileImage(image)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0){
                        
                        // --- ชื่อ ---
                        ProfileInputField(
                            title: "ชื่อ",
                            placeholder: "ป้อนชื่อของคุณ",
                            text: $viewModel.name,
                            isEditing: $viewModel.isEditing,
                            isInvalid: $viewModel.isNameInvalid,
                            isSubmitted: $viewModel.isSubmitted,
                            errorMessage: viewModel.name.isEmpty ? "กรุณากรอกชื่อ" : "กรุณากรอกชื่อให้ถูกต้อง",
                            onEditingChanged: {
                                viewModel.clearError(for: "name")
                            }
                        )
                        // ✅ ใช้ .onChange เพื่อให้กรอบแดงหายทันทีที่ผู้ใช้เริ่มกดปุ่มพิมพ์ (Real-time)
                        .onChange(of: viewModel.name) { _, _ in
                            viewModel.clearError(for: "name")
                        }
                        
                        // --- นามสกุล ---
                        ProfileInputField(
                            title: "นามสกุล",
                            placeholder: "ป้อนนามสกุลของคุณ",
                            text: $viewModel.lastName,
                            isEditing: $viewModel.isEditing,
                            isInvalid: $viewModel.isLastNameInvalid,
                            isSubmitted: $viewModel.isSubmitted,
                            errorMessage: viewModel.lastName.isEmpty ? "กรุณากรอกนามสกุล" : "กรุณากรอกนามสกุลให้ถูกต้อง",
                            onEditingChanged: {
                                viewModel.clearError(for: "lastName")
                            }
                        )
                        .onChange(of: viewModel.lastName) { _, _ in
                            viewModel.clearError(for: "lastName")
                        }
                        
                        // --- อีเมล ---
                        ProfileEmailField(title: "อีเมล", email: viewModel.email, isEditing: $viewModel.isEditing)
                        
                        // --- เบอร์โทร ---
                        ProfileInputField(
                            title: "เบอร์โทร",
                            placeholder: "0XX-XXX-XXXX",
                            text: $viewModel.phoneNumber,
                            isEditing: $viewModel.isEditing,
                            isInvalid: $viewModel.isPhoneInvalid,
                            isSubmitted: $viewModel.isSubmitted,
                            errorMessage: viewModel.phoneNumber.isEmpty ? "กรุณากรอกเบอร์โทร" : "กรุณากรอกเบอร์โทรให้ถูกต้อง",
                            keyboardType: .numberPad,
                            onEditingChanged: {
                                viewModel.clearError(for: "phone")
                            }
                        )
                        .onChange(of: viewModel.phoneNumber) { _, _ in
                            viewModel.clearError(for: "phone")
                        }
                        // --- รหัสผ่าน ---
                        
                        ProfilePasswordField(title: "รหัสผ่าน", password: viewModel.password, isEditing: $viewModel.isEditing,currentEmail: viewModel.email)
                    }
                        
                    
                    Spacer()
                    
                    if viewModel.isEditing {
                        HStack(spacing: 35) {
                            SecondButton(title: "ยกเลิก", action: { viewModel.cancelEditing() }, width: 155, height: 49)
                            PrimaryButton(title: "บันทึก", action: {
                                Task { await viewModel.saveProfile() }
                            }, width: 155, height: 49)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.backgroundColor)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    emailChangeSuccess = false
                    viewModel.isEditing = false
                    NotificationCenter.default.post(name: .popToProfile, object: nil)
                }
            
            if viewModel.showSuccessPopup {
                SuccessPopupView(message: "บันทึกข้อมูลสำเร็จ") {
                    withAnimation { viewModel.showSuccessPopup = false }
                }
            }
            
            if viewModel.showErrorPopup {
                ErrorPopupView(title: "บันทึกไม่สำเร็จ", onDismiss: {
                    withAnimation { viewModel.showErrorPopup = false }
                })
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    ProfileView()
}

