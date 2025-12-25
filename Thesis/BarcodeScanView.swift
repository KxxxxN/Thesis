//
//  BarcodeScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI
import PhotosUI

struct BarcodeScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @State private var showAiScanView = false
    @State private var showSearchView = false
    @State private var showDetailBarcodeView = false
    
    @State private var selectedTabnavigationItem = 0
    @State private var isFlashOn = false
    @State private var showResultAlert = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

//    @State private var aiResult: String = "ขวดพลาสติก"
//
//    // MARK: - Attributed Result Title
//    private var resultTitle: AttributedString {
//        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
//        if let range = text.range(of: aiResult) {
//            text[range].font = .noto(25, weight: .bold)
//        }
//        return text
//    }

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
            
//            GeometryReader { geo in
//                    Image("BarcodeEx")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.width, height: geo.size.height) // กำหนดขนาดให้เท่าหน้าจอ
//                        .clipped() // ตัดส่วนที่ล้นออก
//                }
//                .ignoresSafeArea()

            VStack(spacing: 0) {

                headerView // อยู่บนสุดเสมอ

                VStack {

                    Spacer() // ใช้ Spacer ตัวเดียวดันทุกอย่างลงล่าง แทนการระบุความสูง 509

                    // 📸 Gallery + AI Scan Button
                    HStack {
                        GalleryPickerButton(selectedItem: $selectedItem)
                            .onChange(of: selectedItem) { _, newItem in
                                loadImage(from: newItem)
                            }

                        Spacer()

                        Button {
                            hideTabBar = true
                            showDetailBarcodeView = true
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.mainColor, lineWidth: 3)
                                    .frame(width: 85, height: 85)

                                Circle()
                                    .fill(Color.mainColor)
                                    .frame(width: 73, height: 73)

                                Image("Barcode")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                            }
                        }


                        Spacer()
                        // เพื่อให้ปุ่ม AI อยู่กึ่งกลางพอดี
                        Color.clear.frame(width: 55, height: 1)
                    }
                    .frame(maxWidth: 343)

                    // Navigation Bar ด้านล่าง
                    AiScanBottomNavigationBar(
                        selectedTab: $selectedTabnavigationItem
                    ) { index in
                        hideTabBar = true   // ⭐ ซ่อน MainTabBar

                        switch index {
                        case 0:
                            break
                        case 1:
                            showAiScanView = true

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
 
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .fullScreenCover(isPresented: $showAiScanView) {
            AiScanView(hideTabBar: $hideTabBar)
        }
        .fullScreenCover(isPresented: $showSearchView) {
            SearchView(hideTabBar: $hideTabBar)
        }
        .fullScreenCover(isPresented: $showDetailBarcodeView) {
            DetailBarcodeView(hideTabBar: $hideTabBar)
        }

    }

    // MARK: - Header (ปรับปรุงใหม่)
    private var headerView: some View {
        HStack {
            BackButton()

            Spacer()

                Text("สแกนบาร์โค้ด")
                    .font(.noto(25, weight: .bold))
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
