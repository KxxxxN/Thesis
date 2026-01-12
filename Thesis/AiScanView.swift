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
        NavigationStack {
            
            ZStack(alignment: .top) {
                
                GeometryReader { geo in
                    ZStack {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    
                    headerView
                    
                    VStack {
                        Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 343, height: 60)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)
                        
                        Spacer()
                            .frame(height: 505)

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
            .onAppear {
                hideTabBar = true
                selectedTabnavigationItem = 1
            }
            .onDisappear { hideTabBar = false }
            .navigationDestination(isPresented: $showDetailView) {
                DetailAiScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showBarcodeView) {
                BarcodeScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showSearchView) {
                SearchView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)

        }
    }

    private var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10,height: 10)

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
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 25)
            }
        }
        .padding(.top, 69)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top)
        )
        .edgesIgnoringSafeArea(.all)

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

