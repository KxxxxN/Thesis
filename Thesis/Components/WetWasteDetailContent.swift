//
//  WetWasteDetailContent.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/3/2569 BE.
//

import SwiftUI

// MARK: - Shared Component
struct WetWasteDetailContent: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let category: String
    var wasteDetail: String? = nil
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false

    // MARK: - Responsive Dimensions (เหมือน GeneralWasteDetailContent)
    private var isIPad: Bool { horizontalSizeClass == .regular }
    private var contentPaddingH: CGFloat { isIPad ? 60 : 37 }
    
    private var titleFontSize: CGFloat { isIPad ? 36 : 25 }
    private var sectionTitleFontSize: CGFloat { isIPad ? 28 : 20 }
    private var bodyFontSize: CGFloat { isIPad ? 22 : 17 }
    private var stepTextFontSize: CGFloat { isIPad ? 20 : 15 }
    private var binTextFontSize: CGFloat { isIPad ? 16 : 12 }
    
    private var mainBinHeight: CGFloat { isIPad ? 150 : 108 }
    private var stepImageSize: CGFloat { isIPad ? 120 : 80 }
    private var binIconSize: CGFloat { isIPad ? 60 : 40 }
    private var arrowSize: CGFloat { isIPad ? 30 : 20 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ชื่อขยะและวันที่
            HStack(spacing: 12) {
                Text(category)
                    .font(.noto(titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(stepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, isIPad ? 12 : 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, contentPaddingH)
            
            // รายละเอียดตัวอย่างขยะ
            if let wasteDetail = wasteDetail {
                Text(wasteDetail)
                    .font(.noto(isIPad ? 24 : 18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, contentPaddingH)
            }
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin1") // ถังขยะเปียกสีเขียว
                    .resizable()
                    .scaledToFit()
                    .frame(height: mainBinHeight)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(sectionTitleFontSize, weight: .bold))
                    HStack(spacing: 0) {
                        Text("ถังขยะเปียก ")
                            .font(.noto(isIPad ? 24 : 18, weight: .medium))
                        Text("(สีเขียว)")
                            .font(.noto(isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.wetWasteColor)
                    }
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, contentPaddingH)
            
            // วิธีการแยกขยะ
            VStack(alignment: .leading, spacing: 10) {
                Text("วิธีการแยกขยะ")
                    .font(.noto(sectionTitleFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, contentPaddingH)
                
                HStack(alignment: .top, spacing: 0) {
                    ForEach(separationSteps.indices, id: \.self) { index in
                        if index > 0 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .font(.system(size: arrowSize))
                                .padding(.horizontal, 2)
                                .padding(.top, stepImageSize / 2 - (arrowSize / 2)) // จัดให้อยู่กึ่งกลางรูปภาพ
                        }
                        
                        VStack(spacing: 0) {
                            Image(separationSteps[index].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: stepImageSize, height: stepImageSize)
                                .padding(.bottom, 10)
                            
                            Text(separationSteps[index].text)
                                .font(.noto(stepTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                // กำหนด minHeight เพื่อให้ถังขยะด้านล่างบรรทัดเท่ากัน
                                .frame(maxWidth: .infinity, minHeight: isIPad ? 60 : 45, alignment: .top)
                            
                            Spacer().frame(height: 10)
                            
                            // ถังขยะขนาดเล็กด้านล่างขั้นตอน
                            if index < binSteps.count {
                                VStack(spacing: 2) {
                                    Image(binSteps[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: binIconSize, height: binIconSize)
                                    Text(binSteps[index].text)
                                        .font(.noto(binTextFontSize, weight: .medium))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, isIPad ? 20 : 10)
            }
            .padding(.top, 30)
            
            // การรีไซเคิล
            VStack(alignment: .leading, spacing: 10) {
                Text("การรีไซเคิล")
                    .font(.noto(sectionTitleFontSize, weight: .bold))
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
                            .font(.noto(bodyFontSize, weight: .medium))
                    }
                }
            }
            .padding(.horizontal, contentPaddingH)
            .padding(.top, 30)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.knowledgeBackground
                .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
        )
    }
}


// MARK: - เศษอาหาร
struct WetWasteDetailFoodscraps: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "เศษอาหาร",
            wasteDetail: "เช่น ข้าว เศษผัก เศษเนื้อ ก้างปลา กระดูกไก่",
            separationSteps: [
                WasteSeparationStep(imageName: "step_food_1", text: "เทเศษอาหาร \nออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_food_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "ทำปุ๋ยหมักจากเศษอาหาร",
                "นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้",
                "ใช้เป็นอาหารปลา \n    (เฉพาะเศษผัก ผลไม้ และเศษอาหารชิ้นเล็กๆ)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เปลือกผลไม้
struct WetWasteDetailFruitPeel: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "เปลือกผลไม้",
            separationSteps: [
                WasteSeparationStep(imageName: "step_fruit_1", text: "แยกออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_fruit_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "ตากแห้งทำปุ๋ยหมัก",
                "ทำปุ๋ยน้ำหมักชีวภาพ",
                "ใช้เป็นน้ำหมักไล่แมลงอ่อน ๆ"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เศษขนม
struct WetWasteDetailCrumbs: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "เศษขนม",
            wasteDetail: "เช่น ขนมขบเคี้ยว คุกกี้ ขนมปัง เค้ก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_snack_1", text: "เทเศษขนมออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_snack_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำไปทำปุ๋ยหมัก",
                "นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้",
                "ใช้เลี้ยงสัตว์เล็กบางชนิด \n    (เฉพาะเศษขนมที่เหมาะสม)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เปลือกไข่
struct WetWasteDetailEggshell: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "เปลือกไข่",
            separationSteps: [
                WasteSeparationStep(imageName: "step_eggshell_1", text: "แยกออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_eggshell_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "บดผสมดินเพิ่มแคลเซียมให้ต้นไม้",
                "ใส่กระถางช่วยบำรุงดิน",
                "นำไปใช้เป็นปุ๋ยธรรมชาติ"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เครื่องดื่มเหลือ
struct WetWasteDetailLeftoverDrinks: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "เครื่องดื่มเหลือ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_drink_1", text: "เทเครื่องดื่มออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_drink_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำไปหมักเป็นปุ๋ยน้ำหมัก",
                "นำไปเจือจางแล้วใช้รดต้นไม้ \n    (เฉพาะเครื่องดื่มที่ไม่หวานจัด ไม่เค็ม และไม่มีก๊าซ)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - น้ำแข็งเหลือ
struct WetWasteDetailLeftoverIce: View {
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            category: "น้ำแข็งเหลือ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_ice_1", text: "เทน้ำแข็งออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_ice_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำมาใช้รดน้ำต้นไม้",
                "เทลงอ่างเพื่อล้างทำความสะอาด"
            ],
            showDate: showDate
        )
    }
}

#Preview {
    ScrollView {
        WetWasteDetailFoodscraps()
        WetWasteDetailFruitPeel()
        WetWasteDetailEggshell()
        WetWasteDetailCrumbs()
        WetWasteDetailLeftoverDrinks()
        WetWasteDetailLeftoverIce()
    }
}

