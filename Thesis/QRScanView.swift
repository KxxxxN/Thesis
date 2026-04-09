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
    
    // MARK: - Result Title Formatting
    // เปลี่ยนเป็น Function เพื่อรับค่า fontSize จาก Config
    private func resultTitle(fontSize: CGFloat) -> AttributedString {
        var text = AttributedString(qrResult)
        text.font = .noto(fontSize, weight: .medium)
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(fontSize, weight: .medium)
        }
        return text
    }

    // MARK: - Body
    var body: some View {
        // คลุม GeometryReader ไว้ชั้นนอกสุดเพื่อสร้าง config ตัวเดียวใช้ทั้ง View
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            let isLandscape = geo.size.width > geo.size.height

            ZStack(alignment: .top) {
                
                Image("QRBackground")
                    .resizable()
                    .scaledToFill()
                    // เปลี่ยนมาใช้ maxWidth, maxHeight แทน geo.size
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView(config: config)

                    // 1. นำ GeometryReader มาครอบ ScrollView เพื่อดึงพื้นที่ความสูงที่เหลือใต้ Header
                    GeometryReader { scrollGeo in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                Text("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน")
                                    .font(.noto(config.instructionFont, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .minimumScaleFactor(0.8)
                                    .padding(.vertical, config.instructionPaddingV)
                                    .frame(maxWidth: config.qrContentMaxWidth)
                                    .background(Color.textFieldColor)
                                    .cornerRadius(20)
                                    .padding(.horizontal, 20)
                                    .padding(.top, config.instructionPaddingTop)
                                
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
                                .frame(
                                    width: isLandscape ? config.cameraSize * 0.6 : config.cameraSize,
                                    height: isLandscape ? config.cameraSize * 0.6 : config.cameraSize
                                )
                                .padding(.top, isLandscape ? 20 : config.cameraPaddingTop)
                                
                                // 2. ลบ Color.clear.frame(height: 800) ทิ้ง แล้วใช้ Spacer แทน
                                Spacer(minLength: 40)
                            }
                            // 3. กำหนด minHeight ให้เท่ากับความสูงของ scrollGeo
                            .frame(maxWidth: .infinity, minHeight: scrollGeo.size.height)
                        }
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
                                .frame(width: config.alertIconSize, height: config.alertIconSize)
                                .padding(.top, 25)

                            Text("ยืนยันถังขยะ")
                                .font(.noto(config.alertTitleFont, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)

                            Text(resultTitle(fontSize: config.alertResultFont))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)

                            HStack(spacing: config.alertButtonSpacing) {
                                Button {
                                    showResultAlert = false
                                    cameraID = UUID()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isScanning = true
                                        isCameraActive = true
                                    }
                                } label: {
                                    Text("ยกเลิก")
                                        .font(.noto(config.buttonFont, weight: .bold))
                                        .foregroundColor(.mainColor)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: config.buttonHeight)
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
                                        .font(.noto(config.buttonFont, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: config.buttonHeight)
                                        .background(Color.mainColor)
                                        .cornerRadius(25)
                                }
                            }
                            .padding(25)
                        }
                        .padding(20)
                        .frame(maxWidth: config.qrContentMaxWidth)
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
            .frame(width: geo.size.width, height: geo.size.height)
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
    }

    // MARK: - Header View
        private func headerView(config: ResponsiveConfig) -> some View {
            ZStack {
                // 1. ข้อความตรงกลาง
                Text("สแกนคิวอาร์โค้ดถังขยะ")
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 60)

                // 2. ปุ่มซ้ายขวา
                HStack {
                    XBackButtonBlack(index: $index)
                    
                    Spacer()

                    Button { isFlashOn.toggle() } label: {
                        Image(isFlashOn ? "FlashOn" : "FlashOff")
                            .resizable()
                            .scaledToFit()
                            .frame(width: config.headerIconSize, height: config.headerIconSize)
                    }
                }
                // 📍 แก้ไขตรงนี้: ล็อกความกว้างของปุ่มซ้าย-ขวา ไม่ให้กางออกไปสุดขอบจอแนวนอน
                // โดยให้กว้างสุดเท่ากับกล่อง QR Content + เผื่อระยะขอบนิดหน่อย
                .frame(maxWidth: config.qrContentMaxWidth + 60)
                .padding(.horizontal, config.headerSidePadding)
            }
            .padding(.top, config.headerTopPadding)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor.ignoresSafeArea(edges: [.top, .horizontal]))
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
