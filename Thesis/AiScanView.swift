//
//  AiScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import PhotosUI

struct AiScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @State private var showBarcodeView = false
    @State private var showSearchView = false
    
    @State private var selectedTabnavigationItem = 1
    @State private var isFlashOn = false
    @State private var showResultAlert = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    @State private var aiResult: String = "ขวดพลาสติก"

    // MARK: - Attributed Result Title
    private var resultTitle: AttributedString {
        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
        if let range = text.range(of: aiResult) {
            text[range].font = .noto(25, weight: .bold)
        }
        return text
    }

    var body: some View {
        ZStack(alignment: .top) {

            GeometryReader { geo in
                ZStack {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFill() // เปลี่ยนเป็น Fill เพื่อให้เต็มจอเหมือนกล้อง
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .background(Color.cameraBackground)
                    } else {
                        CameraPreview()
                        Color.black.opacity(0.25)
                    }
                }
                .ignoresSafeArea()
            }

            VStack(spacing: 0) {

                headerView // อยู่บนสุดเสมอ

                VStack {
                    Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                        .font(.noto(20, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 343, height: 60)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        .padding(.top, 34)

                    Spacer() // ใช้ Spacer ตัวเดียวดันทุกอย่างลงล่าง แทนการระบุความสูง 509

                    // 📸 Gallery + AI Scan Button
                    HStack {
                        GalleryPickerButton(selectedItem: $selectedItem)
                            .onChange(of: selectedItem) { _, newItem in
                                loadImage(from: newItem)
                            }

                        Spacer()

                        Button {
                            showResultAlert = true
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.mainColor, lineWidth: 3)
                                    .frame(width: 85, height: 85)

                                Circle()
                                    .fill(Color.mainColor)
                                    .frame(width: 73, height: 73)

                                Image("Tabler_ai")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 57, height: 57)
                            }
                        }

                        Spacer()
                        // เพื่อให้ปุ่ม AI อยู่กึ่งกลางพอดี
                        Color.clear.frame(width: 55, height: 1)
                    }
                    .frame(maxWidth: 343)

                    AiScanBottomNavigationBar(
                        selectedTab: $selectedTabnavigationItem
                    ) { index in
                        hideTabBar = true   // ⭐ ซ่อน MainTabBar

                        switch index {
                        case 0:
                            showBarcodeView = true
                        case 1:
                            // อยู่หน้าเดิม (AiScan)
                            break

                        case 2:
                            // ไปหน้าค้นหา
                            showSearchView = true

                        default:
                            break
                        }
                    }
                    .padding(.bottom, 25)
                    .padding(.top, 21)
                }
            }

            // ===============================
            // 🔔 Custom Alert
            // ===============================
            if showResultAlert {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.8)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Text(resultTitle)
                            .font(.noto(25, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        HStack(spacing: 21) {
                            Button {
                                selectedImage = nil
                                showResultAlert = false
                            } label: {
                                Text("สแกนใหม่")
                                    .font(.noto(16, weight: .bold))
                                    .foregroundColor(.mainColor)
                                    .frame(width: 120, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.mainColor, lineWidth: 2)
                                    )
                            }

                            Button {
                                showResultAlert = false
                                showDetailView = true
                            } label: {
                                Text("ถูกต้อง")
                                    .font(.noto(16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 40)
                                    .background(Color.mainColor)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(20)
                    .frame(width: 343, height: 255)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .fullScreenCover(isPresented: $showDetailView) {
            DetailAiScanView(hideTabBar: $hideTabBar)
        }
        .fullScreenCover(isPresented: $showBarcodeView) {
            BarcodeScanView(hideTabBar: $hideTabBar)
        }
        .fullScreenCover(isPresented: $showSearchView) {
            SearchView(hideTabBar: $hideTabBar)
        }
    }

    // MARK: - Header (ปรับปรุงใหม่)
    private var headerView: some View {
        HStack {
            BackButton()

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("สแกนด้วย ")
                    .font(.noto(25, weight: .bold))
                Text("AI")
                    .font(.inter(25, weight: .bold))
            }
            .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(systemName: isFlashOn ? "bolt.fill" : "bolt")
                    .font(.system(size: 25))
                    .foregroundColor(.black)
                    .padding(.trailing, 25)
            }
        }
        .padding(.bottom, 15) // เว้นระยะห่างด้านล่างเนื้อหา
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top) // ให้สีพื้นหลังถมส่วน Notch/Status Bar
        )
    }

    // MARK: - Load Image Function
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
