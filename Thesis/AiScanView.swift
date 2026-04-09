//
//  AiScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct AiScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    
    @State private var showDetailView = false
    @State private var showBarcodeView = false
    @State private var showSearchView = false

    @State private var selectedTabnavigationItem = 1
    @State private var isFlashOn = false
    @State private var showResultAlert = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isCameraActive = true

    @State private var capturedUIImage: UIImage? = nil  // ✅ รับภาพจากกล้อง
    @State private var shouldCapture = false             // ✅ trigger ถ่าย
    @State private var isAnalyzing = false

    @State private var aiResult: String = "ขวดพลาสติก"
    
    @State private var isScanning = true

    private func resultTitle(config: ResponsiveConfig) -> AttributedString {
        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
        if let range = text.range(of: aiResult) {
            text[range].font = .noto(config.alertTitleFont, weight: .bold)
        }
        return text
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
                
                ZStack(alignment: .top) {
                    
                    // MARK: - ส่วน Background (ภาพหรือกล้อง)
                    ZStack {
                        if let uiImage = capturedUIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                                .background(Color.cameraBackground)
                        } else if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                                .background(Color.cameraBackground)
                        } else {
                            CameraPreview(
                                isScanning: $isScanning,
                                isActive: $isCameraActive,
                                capturedImage: $capturedUIImage,
                                isFlashOn: $isFlashOn,
                                shouldCapture: shouldCapture
                            )
                            Color.black.opacity(0.25)
                        }
                    }
                    .ignoresSafeArea()

                    // MARK: - ส่วน Foreground (UI ซ้อนทับด้านบน)
                    VStack(spacing: 0) {

                        headerView(config: config)

                        VStack {
                            Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                                .font(.noto(config.fontBody, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, config.paddingSmall)
                                .padding(.vertical, config.paddingSmall)
                                .frame(maxWidth: config.qrContentMaxWidth, minHeight: config.isIPad ? 80 : 60)
                                .background(Color.textFieldColor)
                                .cornerRadius(config.bannerCornerRadius)
                                .padding(.horizontal, config.paddingMedium)

                            Spacer()

                            HStack {
                                GalleryPickerButton(selectedItem: $selectedItem)
                                    .onChange(of: selectedItem) { _, newItem in
                                        loadImage(from: newItem)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button {
                                    if capturedUIImage != nil || selectedImage != nil {
                                        analyzeImage()
                                    } else {
                                        shouldCapture = true
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)
                                            .frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)

                                        Circle()
                                            .fill(Color.mainColor)
                                            .frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)

                                         Image("Tabler_ai")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.aiButtonIconSize, height: config.aiButtonIconSize)
                                    }
                                }

                                Color.clear
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal, config.paddingStandard)

                            AiScanBottomNavigationBar(
                                selectedTab: $selectedTabnavigationItem
                            ) { index in
                                hideTabBar = true
                                switch index {
                                case 0: showBarcodeView = true
                                case 1: break
                                case 2: showSearchView = true
                                default: break
                                }
                            }
                            .padding(.bottom, config.paddingStandard)
                            .padding(.top, config.spacingSmall)
                        }
                    }

                    // MARK: - Alert overlay
                    if showResultAlert {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.8)
                                .ignoresSafeArea()

                            VStack(spacing: config.spacingMedium) {
                                Text(resultTitle(config: config))
                                    .font(.noto(config.alertTitleFont, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่")
                                    .font(.noto(config.alertResultFont, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: config.alertButtonSpacing) {
                                    Button {
                                        capturedUIImage = nil
                                        selectedImage = nil
                                        selectedItem = nil
                                        shouldCapture = false
                                        showResultAlert = false
                                    } label: {
                                        Text("สแกนใหม่")
                                            .font(.noto(config.buttonFont, weight: .bold))
                                            .foregroundColor(.mainColor)
                                            .frame(maxWidth: .infinity, minHeight: config.buttonHeight)
                                            .background(Color.white)
                                            .cornerRadius(config.buttonHeight / 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: config.buttonHeight / 2)
                                                    .stroke(Color.mainColor, lineWidth: 2)
                                            )
                                    }

                                    Button {
                                        showResultAlert = false
                                        showDetailView = true
                                    } label: {
                                        Text("ถูกต้อง")
                                            .font(.noto(config.buttonFont, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: config.buttonHeight)
                                            .background(Color.mainColor)
                                            .cornerRadius(config.buttonHeight / 2)
                                    }
                                }
                                .padding(.top, config.spacingSmall)
                            }
                            .padding(config.paddingStandard)
                            .frame(maxWidth: config.qrContentMaxWidth)
                            .background(Color.white)
                            .cornerRadius(config.bannerCornerRadius)
                            .padding(.horizontal, config.paddingStandard)
                        }
                    }

                    // MARK: - Analyzing overlay
                    if isAnalyzing {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()

                            ProgressView()
                                .scaleEffect(config.isIPad ? 2.5 : 1.5)
                                .padding(config.paddingStandard)
                                .background(Color.white)
                                .cornerRadius(config.bannerCornerRadius)
                        }
                    }
                }
            }
            .onChange(of: capturedUIImage) { _, newImage in
                if newImage != nil {
                    shouldCapture = false
                    analyzeImage()
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

    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            BackButton()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("สแกนด้วย ")
                    .font(.noto(config.titleFontSize, weight: .bold))
                Text("AI")
                    .font(.inter(config.titleFontSize, weight: .bold))
            }
            .foregroundColor(.black)
            .layoutPriority(1)
            
            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, config.headerSidePadding)
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.paddingMedium)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    capturedUIImage = uiImage
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    private func analyzeImage() {
        isAnalyzing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAnalyzing = false
            aiResult = "ขวดพลาสติก"
            showResultAlert = true
        }
    }
}
