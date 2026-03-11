//
//  WasteSeparationStep.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/3/2569 BE.
//


//
//  RecycleWasteDetail.swift
//  Thesis
//

import SwiftUI

// MARK: - Model
struct WasteSeparationStep {
    let imageName: String
    let text: String
    let imageSize: CGSize = CGSize(width: 90, height: 90)
}
struct WasteBinStep {
    let imageName: String
    let text: String
    let imageSize: CGSize = CGSize(width: 40, height: 40)
}

// MARK: - Shared Component
struct RecycleWasteDetailContent: View {
    let category: String
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
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(20, weight: .bold))
                    HStack(spacing: 0) {
                        Text("ถังขยะรีไซเคิล")
                            .font(.noto(18, weight: .medium))
                        Text("(สีเหลือง)")
                            .font(.noto(18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
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

// MARK: - ขวดพลาสติก
struct RecycleWasteDetailPlasticBottle: View {
    var showDate: Bool = false
    
    private let separationSteps: [WasteSeparationStep] = [
        WasteSeparationStep(imageName: "DetailRecycle1", text: "เทน้ำให้หมด"),
        WasteSeparationStep(imageName: "DetailRecycle2", text: "แยกฝาและฉลาก"),
        WasteSeparationStep(imageName: "DetailRecycle3", text: "บีบขวดให้แบน")
    ]
    
    private let plasticbottleStep: [WasteBinStep] = [
        WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
        WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
        WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
        WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
    ]
    
    private let recyclingMethods: [String] = [
        "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่เครื่องเขียน",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ชื่อขยะและวันที่
            HStack(spacing: 12) {
                Text("ขวดพลาสติก")
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
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(20, weight: .bold))
                    
                    HStack(spacing: 0) {
                        Text("ถังขยะรีไซเคิล ")
                            .font(.noto(18, weight: .medium))
                        Text("(สีเหลือง)")
                            .font(.noto(18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
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
                    .padding(.horizontal, 37)
                
                HStack(spacing: 0) {
                    // ขั้นตอน 1
                    VStack(spacing: 0) {
                        Image("DetailRecycle1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .padding(.bottom, 10)

                        Text("เทน้ำให้หมด")
                            .font(.noto(15, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 130, height: 20, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 1
                        VStack(spacing: 2) {
                            Image("bin-icon1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("ถังขยะเปียก")
                                .font(.noto(12, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 1
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 60)
                    
                    // ขั้นตอน 2
                    VStack(spacing: 0) {
                        Image("DetailRecycle2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .padding(.bottom, 10)
                        Text("แยกฝาและฉลาก")
                            .font(.noto(15, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 130, height: 20, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 2 + 3 ติดกัน
                        HStack(spacing: 5) {
                            VStack(spacing: 2) {
                                Image("bin-icon3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                Text("ถังขยะรีไซเคิล")
                                    .font(.noto(12, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            VStack(spacing: 2) {
                                Image("bin-icon2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                Text("ถังขยะทั่วไป")
                                    .font(.noto(12, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 2
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 60) // ✅ ให้ลูกศรอยู่แถวรูป
                    
                    // ขั้นตอน 3
                    VStack(spacing: 0) {
                        Image("DetailRecycle3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .padding(.bottom, 10)
                        Text("บีบขวดให้แบน")
                            .font(.noto(15, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 130, height: 20, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 4
                        VStack(spacing: 2) {
                            Image("bin-icon3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("ถังขยะรีไซเคิล")
                                .font(.noto(12, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
//                .padding(.horizontal, 1)
            }
            .padding(.top, 30)
            
            
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

// MARK: - แก้วพลาสติก
struct RecycleWasteDetailPlasticCup: View {
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            category: "แก้วพลาสติก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_cup_1", text: "เทน้ำให้หมด"),
                WasteSeparationStep(imageName: "step_plastic_cup_2", text: "ล้างแก้วเล็กน้อย"),
                WasteSeparationStep(imageName: "step_plastic_cup_3", text: "บีบหรือซ้อนแก้ว")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
            ],
            recyclingMethods: [
                "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
                "ทำเป็นที่ใส่เครื่องเขียน",
                "ใช้เป็นที่เพาะต้นอ่อน"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กระป๋อง
struct RecycleWasteDetailCan: View {
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            category: "กระป๋อง",
            separationSteps: [
                WasteSeparationStep(imageName: "step_can_1", text: "เทน้ำให้หมด"),
                WasteSeparationStep(imageName: "step_can_2", text: "ล้างกระป๋อง"),
                WasteSeparationStep(imageName: "step_can_3", text: "บีบให้แบน")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
            ],
            recyclingMethods: [
                "ทำเป็นที่ใส่เครื่องเขียน",
                "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
                "ประดิษฐ์เป็นโคมไฟตกแต่ง",
                "ทำเป็นโมบายหรือกระดิ่งลมแขวน"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กล่องกระดาษ
struct RecycleWasteDetailCardboardBox: View {
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            category: "กล่องกระดาษ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_cardboard_1", text: "แกะเทปและฉลาก"),
                WasteSeparationStep(imageName: "step_cardboard_2", text: "พับกล่องให้แบน")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
            ],
            recyclingMethods: [
                "ใช้ทำเป็นงานประดิษฐ์",
                "ทำกล่องจัดระเบียบและเก็บของ",
                "ตัดเป็นแผ่นรองพัสดุหรือกันกระแทก"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กระดาษทั่วไป
struct RecycleWasteDetailPaper: View {
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            category: "กระดาษทั่วไป",
            separationSteps: [
                WasteSeparationStep(imageName: "step_paper_1", text: "แยกกระดาษแห้ง"),
                WasteSeparationStep(imageName: "step_paper_2", text: "พับหรือมัดรวมกัน"),
                WasteSeparationStep(imageName: "step_paper_3", text: "กระดาษเปียก")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
            ],
            recyclingMethods: [
                "ใช้ซ้ำเป็นกระดาษโน้ต",
                "ทำเป็นงานประดิษฐ์หรือของเล่น",
                "ใช้ห่อกันกระแทก"
            ],
            showDate: showDate
        )
    }
}

// MARK: - ถุงพลาสติก
struct RecycleWasteDetailPlasticBag: View {
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            category: "ถุงพลาสติก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_bag_1", text: "เขย่าเศษ\nอาหารออก"),
                WasteSeparationStep(imageName: "step_plastic_bag_2", text: "ถุงสะอาด\nล้าง-ทำให้แห้ง-พับ"),
                WasteSeparationStep(imageName: "step_plastic_bag_3", text: "ถุงสกปรก"),
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
            ],
            recyclingMethods: [
                "นำกลับมาใช้ซ้ำ",
                "ใช้เป็นถุงใส่ขยะ",
                "ถักเป็นพรมหรือกระเป๋า"
            ],
            showDate: showDate
        )
    }
}

#Preview {
    ScrollView {
        RecycleWasteDetailPlasticBottle()
        RecycleWasteDetailPlasticCup()
        RecycleWasteDetailCan()
        RecycleWasteDetailCardboardBox()
        RecycleWasteDetailPaper()
        RecycleWasteDetailPlasticBag()
    }
}
