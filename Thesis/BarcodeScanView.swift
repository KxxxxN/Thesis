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

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                GeometryReader { geo in
                    ZStack {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill() // เปลี่ยนเป็น Fill เพื่อให้เต็มจอเหมือนกล้อง
                            //                            .frame(width: geo.size.width, height: geo.size.height)
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
                        
                        Spacer()
                            .frame(height: 565)
                        
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
                            hideTabBar = true
                            
                            switch index {
                            case 0:
                                break
                                
                            case 1:
                                showAiScanView = true
                                
                            case 2:
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
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showSearchView) {
                SearchView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showDetailBarcodeView) {
                DetailBarcodeView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)

        }
    }

    // MARK: - Header (ปรับปรุงใหม่)
    private var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10,height: 10)

            Spacer()

                Text("สแกนบาร์โค้ด")
                    .font(.noto(25, weight: .bold))
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
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 123)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top) // ให้สีพื้นหลังถมส่วน Notch/Status Bar
        )
        .edgesIgnoringSafeArea(.top)

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
