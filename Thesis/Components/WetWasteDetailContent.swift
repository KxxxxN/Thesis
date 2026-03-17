//
//  WetWasteDetailContent.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/3/2569 BE.
//

import SwiftUI


// MARK: - Shared Component
struct WetWasteDetailContent: View {
    let category: String
    var wasteDetail: String? = nil
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ชื่อขยะและวันที่
            HStack(spacing: 12) {
                Text(category)
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(15, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 37)
            
            //รายละเอียดตัวอย่างขยะ
            if let wasteDetail = wasteDetail {
                Text(wasteDetail)
                    .font(.noto(18, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 37)
            }
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(20, weight: .bold))
                    HStack(spacing: 0) {
                        Text("ถังขยะเปียก")
                            .font(.noto(18, weight: .medium))
                        Text("(สีเขียว)")
                            .font(.noto(18, weight: .bold))
                            .foregroundColor(.wetWasteColor)
                    }
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, 37)
            
            // วิธีการแยกขยะ
            VStack(alignment: .leading, spacing: 3) {
                Text("วิธีการแยกขยะ")
                    .font(.noto(20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 27)
                
                HStack(spacing: 0) {
                    ForEach(separationSteps.indices, id: \.self) { index in
                        if index > 0 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .padding(.horizontal, 2)
                                .padding(.bottom, 60)
                        }
                        
                        // ✅ รูปขั้นตอน + ถังตรงกัน
                        VStack(spacing: 0) {
                            Image(separationSteps[index].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .padding(.bottom, 10)
                            
                            Text(separationSteps[index].text)
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 120)
                            
                            Spacer()
                            // ✅ ถังตรงกับขั้นตอน
                            if index < binSteps.count {
                                VStack(spacing: 2) {
                                    Image(binSteps[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text(binSteps[index].text)
                                        .font(.noto(12, weight: .medium))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 10)
            
            // การรีไซเคิล
            VStack(alignment: .leading, spacing: 10) {
                Text("การรีไซเคิล")
                    .font(.noto(20, weight: .bold))
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
                            .font(.noto(17, weight: .medium))
                    }
                }
            }
            .padding(.horizontal, 37)
            .padding(.top, 30)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity)
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

