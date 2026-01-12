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
    @State private var selectedImage: Image? = nil

    var body: some View {
        NavigationStack {   // ✅ ต้องอยู่ใน NavigationStack
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
                        Spacer()

                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }

                            Spacer()

                            Button {
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
            .navigationDestination(isPresented: $showSaveSearchPhotoView) {
                SaveSearchPhotoView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)

        }
    }

    var headerView: some View {
        HStack {
            BackButton()
            Spacer()
            Text("ยืนยันภาพถ่าย")
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
//        .padding(.top, 69)
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
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
