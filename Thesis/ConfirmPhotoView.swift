//
//  ConfirmPhotoView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI
import PhotosUI

struct ConfirmPhotoView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var showSaveSearchPhotoView = false

    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var isCameraActive = true
    @State private var shouldCapture = false

    @State private var isScanning = true

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            ZStack(alignment: .top) {

                // MARK: - Background
                ZStack {
                    if let uiImage = selectedUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .background(Color.cameraBackground)
                    } else {
                        CameraPreview(
                            isScanning: $isScanning,
                            isActive: $isCameraActive,
                            capturedImage: $selectedUIImage,
                            isFlashOn: $isFlashOn,
                            shouldCapture: shouldCapture
                        )
                        Color.black.opacity(0.25)
                    }
                }
                .ignoresSafeArea()

                // MARK: - Foreground
                VStack(spacing: 0) {

                    headerView(config: config)

                    VStack {

                        Text("กรุณาถ่ายรูปขยะทีละชิ้น ให้ตรงกับที่ค้นหา")
                            .font(.noto(config.fontHeader, weight: .medium))        // เดิม: 20 → fontHeader 20/28
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: config.qrContentMaxWidth,             // เดิม: 343 → qrContentMaxWidth 343/500
                                   minHeight: config.confirmBannerHeight)           // ใหม่: 60 → confirmBannerHeight 60/80
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)               // เดิม: 20 → bannerCornerRadius 20/25
                            .padding(.top, config.confirmBannerTopPadding)         // ใหม่: 35 → confirmBannerTopPadding 35/50
                            .padding(.horizontal, config.paddingMedium)

                        Spacer()

                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }

                            Spacer()

                            Button {
                                if selectedUIImage != nil {
                                    hideTabBar = true
                                    showSaveSearchPhotoView = true
                                } else {
                                    shouldCapture = true
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)  // เดิม: 3
                                        .frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)  // เดิม: 85

                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)  // เดิม: 73

                                    Image("Camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: config.barcodeShutterIconSize,   // เดิม: 45 → barcodeShutterIconSize 45/57
                                               height: config.barcodeShutterIconSize)
                                }
                            }

                            Spacer()
                            Color.clear.frame(width: 55, height: 1)
                        }
                        .frame(maxWidth: config.qrContentMaxWidth)                 // เดิม: 343
                        .padding(.bottom, config.paddingStandard)                  // เดิม: 25 → paddingStandard 28/40
                    }
                }
            }
            .onChange(of: selectedUIImage) { _, newImage in
                if newImage != nil {
                    shouldCapture = false
                    hideTabBar = true
                    showSaveSearchPhotoView = true
                }
            }
            .navigationDestination(isPresented: $showSaveSearchPhotoView) {
                if let uiImage = selectedUIImage {
                    SaveSearchPhotoView(hideTabBar: $hideTabBar, selectedImage: uiImage)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            BackButton()
            Color.clear.frame(width: config.spacingSmall, height: config.spacingSmall)  // เดิม: 10 → spacingSmall 10/20

            Spacer()

            Text("ยืนยันภาพถ่าย")
                .font(.noto(config.titleFontSize, weight: .bold))   // เดิม: 25 → titleFontSize 25/36
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)  // เดิม: 35 → headerIconSize 35/45
                    .padding(.trailing, config.paddingStandard)                          // เดิม: 25 → paddingStandard 28/40
            }
        }
        .padding(.bottom, config.paddingMedium)        // เดิม: 18 → paddingMedium 16/24
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                }
            }
        }
    }
}
