//
//  QRScanView.swift
//  Thesis
//

import SwiftUI
import AVFoundation
import PhotosUI

struct QRScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @Binding var index: Int

    @State private var isFlashOn = false
    @State private var showResultAlert = false
    @State private var showErrorAlert = false
    @State private var showAiScanView = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isCameraActive = false
    @State private var isScanning = true
    @State private var cameraID = UUID()

    @State private var qrResult: String = ""

    // MARK: - Responsive Dimensions (คำนวณค่าตัวแปรตามขนาดหน้าจอ)
    private var isIPad: Bool { horizontalSizeClass == .regular }
    
    // โครงสร้างทั่วไป
    private var contentMaxWidth: CGFloat { isIPad ? 500 : 343 }
    
    // ส่วน Header
    private var headerTopPadding: CGFloat { isIPad ? 80 : 65 }
    private var headerSidePadding: CGFloat { isIPad ? 30 : 10 }
    private var headerTitleFont: CGFloat { isIPad ? 36 : 25 }
    private var headerIconSize: CGFloat { isIPad ? 45 : 35 }
    
    // ส่วนข้อความแนะนำ
    private var instructionFont: CGFloat { isIPad ? 28 : 20 }
    private var instructionPaddingV: CGFloat { isIPad ? 30 : 20 }
    private var instructionPaddingTop: CGFloat { isIPad ? 80 : 40 }
    
    // ส่วนกล้องสแกน
    private var cameraSize: CGFloat { isIPad ? 450 : 288 }
    private var cameraPaddingTop: CGFloat { isIPad ? 80 : 60 }
    
    // ส่วน Popup Alert
    private var alertIconSize: CGFloat { isIPad ? 140 : 111 }
    private var alertTitleFont: CGFloat { isIPad ? 32 : 25 }
    private var alertResultFont: CGFloat { isIPad ? 24 : 18 }
    private var alertButtonSpacing: CGFloat { isIPad ? 30 : 21 }
    private var buttonHeight: CGFloat { isIPad ? 50 : 40 }
    private var buttonFont: CGFloat { isIPad ? 20 : 16 }

    // MARK: - Result Title Formatting
    private var resultTitle: AttributedString {
        var text = AttributedString(qrResult)
        text.font = .noto(alertResultFont, weight: .medium)
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(alertResultFont, weight: .medium)
        }
        return text
    }

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                Image("QRBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView

                VStack(spacing: 0) {
                    Text("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน")
                        .font(.noto(instructionFont, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, instructionPaddingV)
                        .frame(maxWidth: contentMaxWidth)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.top, instructionPaddingTop)

                    ZStack {
                        CameraPreview(
                            isScanning: $isScanning,
                            isActive: $isCameraActive,
                            capturedImage: .constant(nil),
                            isFlashOn: $isFlashOn,
                            scanMode: true,
                            onScan: { result in
                                qrResult = result
                                isCameraActive = false
                                isScanning = false
                                if result.contains("COSCI") {
                                    showResultAlert = true
                                } else {
                                    showErrorAlert = true
                                }
                            }
                        )
                        .id(cameraID)
                        .cornerRadius(20)
                        
                        QRCornerLines()
                    }
                    .frame(width: cameraSize, height: cameraSize)
                    .padding(.top, cameraPaddingTop)

                    Spacer()
                    Color.clear.frame(height: 50)
                }
            }

            // MARK: - Result Alert
            if showResultAlert {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.8)
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        Image("Passmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: alertIconSize, height: alertIconSize)
                            .padding(.top, 25)

                        Text("ยืนยันถังขยะ")
                            .font(.noto(alertTitleFont, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 10)

                        Text(resultTitle)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        HStack(spacing: alertButtonSpacing) {
                            Button {
                                showResultAlert = false
                                cameraID = UUID()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isScanning = true
                                    isCameraActive = true
                                }
                            } label: {
                                Text("ยกเลิก")
                                    .font(.noto(buttonFont, weight: .bold))
                                    .foregroundColor(.mainColor)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: buttonHeight)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.mainColor, lineWidth: 2)
                                    )
                            }

                            Button {
                                hideTabBar = true
                                showResultAlert = false
                                showAiScanView = true
                            } label: {
                                Text("ยืนยัน")
                                    .font(.noto(buttonFont, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: buttonHeight)
                                    .background(Color.mainColor)
                                    .cornerRadius(25)
                            }
                        }
                        .padding(25)
                    }
                    .padding(20)
                    .frame(maxWidth: contentMaxWidth)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                }
            }

            // MARK: - Error Alert
            if showErrorAlert {
                ErrorPopupView(title: "สแกนไม่สำเร็จ") {
                    showErrorAlert = false
                    cameraID = UUID()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isScanning = true
                        isCameraActive = true
                    }
                }
            }
        }
        .onAppear {
            hideTabBar = true
            isCameraActive = true
        }
        .onDisappear {
            hideTabBar = false
            isCameraActive = false
        }
        .navigationDestination(isPresented: $showAiScanView) {
            AiScanView(hideTabBar: $hideTabBar)
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            XBackButtonBlack(index: $index)
                .padding(.leading, headerSidePadding)
            
            Color.clear.frame(width: 10, height: 10)

            Spacer()

            Text("สแกนคิวอาร์โค้ดถังขยะ")
                .font(.noto(headerTitleFont, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: headerIconSize, height: headerIconSize)
                    .padding(.trailing, headerSidePadding)
            }
        }
        .padding(.top, headerTopPadding)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}

// MARK: - QR Frame View
struct QRScanFrameView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("QR")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                QRCornerLines()
            }
            .background(Color.white)
        }
    }
}

// MARK: - QR Corner Lines
struct QRCornerLines: View {
    let lineLength: CGFloat = 30
    let lineWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                path.move(to: CGPoint(x: 0, y: lineLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: lineLength, y: 0))

                path.move(to: CGPoint(x: w - lineLength, y: 0))
                path.addLine(to: CGPoint(x: w, y: 0))
                path.addLine(to: CGPoint(x: w, y: lineLength))

                path.move(to: CGPoint(x: 0, y: h - lineLength))
                path.addLine(to: CGPoint(x: 0, y: h))
                path.addLine(to: CGPoint(x: lineLength, y: h))

                path.move(to: CGPoint(x: w - lineLength, y: h))
                path.addLine(to: CGPoint(x: w, y: h))
                path.addLine(to: CGPoint(x: w, y: h - lineLength))
            }
            .stroke(Color.mainColor, lineWidth: lineWidth)
        }
    }
}
