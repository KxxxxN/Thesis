import SwiftUI
import PhotosUI

struct QRScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @Binding var index: Int 
    
    @State private var isFlashOn = false
    @State private var showResultAlert = false
    @State private var showErrorAlert = false
    @State private var showAiScanView = false
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    @State private var qrResult: String = "อาคาร COSCI ชั้น 3"
    
    // MARK: - Attributed Result Title
    private var resultTitle: AttributedString {
        var text = AttributedString(qrResult)
        
        // 1. กำหนดฟอนต์เริ่มต้นให้กับข้อความทั้งหมดเป็น Noto
        text.font = .noto(18, weight: .medium)
        
        // 2. ค้นหาเฉพาะคำว่า "COSCI" แล้วเปลี่ยนฟอนต์เป็น Inter
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(18, weight: .medium)
        }
        
        return text
    }

    var body: some View {
            ZStack(alignment: .top) {
                
                GeometryReader { geo in
                    Image("QRBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height) // กำหนดขนาดให้เท่าหน้าจอ
                        .clipped() // ตัดส่วนที่ล้นออก
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    headerView
                    
                    VStack(spacing: 0) {
                        
                        Button(action: {
                            showResultAlert = true
                        }) {
                            Text("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน")
                                .font(.noto(20, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(width: 343, height: 115)
                                .background(Color.textFieldColor)
                                .cornerRadius(20)
                        }
                        .padding(.top, 62) // ระยะห่างจาก Header
                        
                        
                        // เฟรมสแกน QR
                        QRScanFrameView()
                            .padding(.top, 93)
                            .onTapGesture {
                                showErrorAlert = true // เมื่อกดที่เฟรม ให้แสดง Error Alert
                            }
                        
                        Spacer()
                        
                        Color.clear.frame(height: 50)
                    }
                }
                
                // ===============================
                // 🔔 Custom Alert (Overlay)
                // ===============================
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
                                .frame(width: 111, height: 111)
                                .multilineTextAlignment(.center)
                                .padding(.top, 25)
                            
                            Text("ยืนยันถังขยะ")
                                .font(.noto(25, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 10)
                            
                            Text(resultTitle)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                            
                            
                            HStack(spacing: 21) {
                                Button {
                                    showResultAlert = false
                                } label: {
                                    Text("ยกเลิก")
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
                                    hideTabBar = true
                                    showResultAlert = false
                                    showAiScanView = true
                                } label: {
                                    Text("ยืนยัน")
                                        .font(.noto(16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 40)
                                        .background(Color.mainColor)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(25)
                        }
                        .padding(20)
                        .frame(width: 343, height: 320)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
                if showErrorAlert {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showErrorAlert = false // กดที่ว่างแล้วปิด Alert
                            }
                        
                        VStack(spacing: 0) {
                            Image("Errormark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 137, height: 137)
                                .multilineTextAlignment(.center)
                            
                            Text("สแกนไม่สำเร็จ")
                                .font(.noto(25, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("กรุณาลองใหม่อีกครั้ง")
                                .font(.noto(18, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                            
                        }
                        .padding(20)
                        .frame(width: 343, height: 260)
                        .background(Color.white)
                        .cornerRadius(20)
                        .onTapGesture {
                        }
                    }
                }
            }
            .onAppear { hideTabBar = true }
            .onDisappear { hideTabBar = false }
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
        }


    // MARK: - Header
    private var headerView: some View {
        HStack {
            XBackButtonBlack(index: $index)
            Color.clear.frame(width: 10,height: 10)

            Spacer()

            Text("สแกนคิวอาร์โค้ดถังขยะ")
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
        .padding(.top, 65)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundColor
                .ignoresSafeArea(edges: .top)
        )
    }
}

// MARK: - QR Frame View
struct QRScanFrameView: View {
    var body: some View {
        ZStack {
            Image("QR")
                .resizable()
                .scaledToFill()
                .frame(width: 288, height: 288)
                .clipped()

            QRCornerLines()
        }
        .frame(width: 288, height: 288)
        .background(Color.white)
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
                // Top-left
                path.move(to: CGPoint(x: 0, y: lineLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: lineLength, y: 0))

                // Top-right
                path.move(to: CGPoint(x: w - lineLength, y: 0))
                path.addLine(to: CGPoint(x: w, y: 0))
                path.addLine(to: CGPoint(x: w, y: lineLength))

                // Bottom-left
                path.move(to: CGPoint(x: 0, y: h - lineLength))
                path.addLine(to: CGPoint(x: 0, y: h))
                path.addLine(to: CGPoint(x: lineLength, y: h))

                // Bottom-right
                path.move(to: CGPoint(x: w - lineLength, y: h))
                path.addLine(to: CGPoint(x: w, y: h))
                path.addLine(to: CGPoint(x: w, y: h - lineLength))
            }
            .stroke(Color.mainColor, lineWidth: lineWidth)
        }
    }
}
