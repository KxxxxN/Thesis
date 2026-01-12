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
    @Binding var hideTabBar: Bool
    @State private var showSaveSearchPhotoView = false

    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil // 🔹 เปลี่ยนเป็น UIImage

    var body: some View {
            ZStack(alignment: .top) {

                GeometryReader { geo in
                    ZStack {
                        if let uiImage = selectedUIImage {
                            Image(uiImage: uiImage) // 🔹 แสดง Image จาก UIImage
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
                        Spacer()

                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }

                            Spacer()

                            Button {
                                guard selectedUIImage != nil else { return }
                                hideTabBar = true
                                showSaveSearchPhotoView = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color.mainColor, lineWidth: 3)
                                        .frame(width: 85, height: 85)

                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: 73, height: 73)

                                    Image("Camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                }
                            }

                            Spacer()
                            Color.clear.frame(width: 55, height: 1)
                        }
                        .frame(maxWidth: 343)
                        .padding(.bottom, 25)
                        .padding(.top, 21)
                    }
                }
            }
            // 🔹 ส่ง selectedUIImage ไป SaveSearchPhotoView
            .navigationDestination(isPresented: $showSaveSearchPhotoView) {
                if let uiImage = selectedUIImage {
                    SaveSearchPhotoView(hideTabBar: $hideTabBar, selectedImage: uiImage)
                }
            }
            .navigationBarHidden(true)
    }

    var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10,height: 10)

            Spacer()
            
            Text("ยืนยันภาพถ่าย")
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
        .padding(.bottom, 18)
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
                    selectedUIImage = uiImage // 🔹 เก็บเป็น UIImage
                }
            }
        }
    }
}

