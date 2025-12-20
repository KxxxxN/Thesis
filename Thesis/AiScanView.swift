import SwiftUI
import PhotosUI

struct AiScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    
    @State private var selectedTabnavigationItem = 1
    @State private var isFlashOn = false
    @State private var showResultAlert = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    // 🔥 ผลสแกนจาก AI (เปลี่ยนได้ภายหลัง)
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
        ZStack {

            GeometryReader { geo in
                ZStack {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height
                            )
                            .background(Color.cameraBackground)
                    } else {
                        CameraPreview()
                        Color.black.opacity(0.25)
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            // ===============================
            // 🔥 Main Content
            // ===============================
            VStack(spacing: 0) {

                headerView
                    .ignoresSafeArea()


                VStack {

//                    Spacer().frame(height: 34)

                    Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                        .font(.noto(20, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 343, height: 60)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)

                    Spacer()
                        .frame(height: 509)

                    // 📸 Gallery + AI Scan
                    HStack {

                        // 📷 Gallery (ใช้รูป)
                        GalleryPickerButton(selectedItem: $selectedItem)
                            .onChange(of: selectedItem) { _, newItem in
                                loadImage(from: newItem)
                            }


                        Spacer()

                        // ✨ AI Scan (ใช้รูป)
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
                        Spacer().frame(width: 55)
                    }

                    .frame(maxWidth: 343)

                    Spacer()
                        .frame(height: 21)

                    AiScanBottomNavigationBar(
                        selectedTab: $selectedTabnavigationItem
                    )
                    .padding(.bottom, 25)

                }
            }

            // ===============================
            // 🔔 Custom Alert (Theme)
            // ===============================
            if showResultAlert {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.8)
                    .ignoresSafeArea()

                VStack(spacing: 16) {

                    Text(resultTitle)
                        .font(.noto(25, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(0)

                    Text("""
ผลการสแกนตรงกับขยะของคุณหรือไม่?
หากไม่ถูกต้อง กรุณาสแกนใหม่
""")
                    .font(.noto(16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(0)

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
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
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
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
                .frame(width: 343, height: 255)
                .background(Color.white)
                .cornerRadius(20)
            }
        }
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .fullScreenCover(isPresented: $showDetailView) {
            DetailAiScanView(hideTabBar: $hideTabBar)
        }
    }

    // MARK: - Load Image
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

    // MARK: - Header
    private var headerView: some View {
        HStack {
            
            BackButton()

            Spacer()

            Text("สแกนด้วย AI")
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
        .padding(.top, 65)
        .padding(.bottom, 15)
        .frame(height: 122)
        .background(Color.backgroundColor.opacity(0.9))
    }
} 
