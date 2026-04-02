//
//  RecycleWasteDetail.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/3/2569 BE.
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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let category: String
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false
    
    // MARK: - Responsive Dimensions
    private var isIPad: Bool { horizontalSizeClass == .regular }
    private var contentPaddingH: CGFloat { isIPad ? 60 : 30 }
    
    private var titleFontSize: CGFloat { isIPad ? 36 : 25 }
    private var sectionTitleFontSize: CGFloat { isIPad ? 28 : 20 }
    private var bodyFontSize: CGFloat { isIPad ? 22 : 17 }
    private var stepTextFontSize: CGFloat { isIPad ? 20 : 15 }
    private var binTextFontSize: CGFloat { isIPad ? 16 : 12 }
    
    private var mainBinHeight: CGFloat { isIPad ? 150 : 108 }
    private var stepImageSize: CGFloat { isIPad ? 120 : 80 }
    private var binIconSize: CGFloat { isIPad ? 60 : 40 }
    private var arrowSize: CGFloat { isIPad ? 30 : 20 }
    private var arrowBottomPadding: CGFloat { isIPad ? 90 : 60 }

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
                        .padding(.top, 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, contentPaddingH)
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: mainBinHeight)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(sectionTitleFontSize, weight: .bold))
                    HStack(spacing: 0) {
                        Text("ถังขยะรีไซเคิล ")
                            .font(.noto(isIPad ? 24 : 18, weight: .medium))
                        Text("(สีเหลือง)")
                            .font(.noto(isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
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
                                .padding(.top, stepImageSize / 2 - (arrowSize / 2)) // จัดลูกศรให้อยู่กึ่งกลางรูป
                        }
                        
                        // ✅ รูปขั้นตอน + ถังตรงกัน
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
                                .frame(maxWidth: .infinity, minHeight: isIPad ? 60 : 45, alignment: .top)
                            
                            Spacer().frame(height: 10)
                            
                            // ✅ ถังตรงกับขั้นตอน
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
                        .frame(maxWidth: .infinity) // ให้ช่องแบ่งเท่าๆ กัน
                    }
                }
                .padding(.horizontal, isIPad ? contentPaddingH : 10)
            }
            .padding(.top, 30)
            
            // การรีไซเคิล
            VStack(alignment: .leading, spacing: 10) {
                Text("การรีไซเคิล")
                    .font(.noto(sectionTitleFontSize, weight: .bold))
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
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

// MARK: - ขวดพลาสติก (Custom Layout Component)
struct RecycleWasteDetailPlasticBottle: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var showDate: Bool = false
    
    private let recyclingMethods: [String] = [
        "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่เครื่องเขียน",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    // MARK: - Responsive Dimensions
    private var isIPad: Bool { horizontalSizeClass == .regular }
    private var contentPaddingH: CGFloat { isIPad ? 60 : 30 }
    
    private var titleTopPadding: CGFloat { isIPad ? 80 : 65 }
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
                Text("ขวดพลาสติก")
                    .font(.noto(titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(stepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, contentPaddingH)
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: mainBinHeight)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(sectionTitleFontSize, weight: .bold))
                    
                    HStack(spacing: 0) {
                        Text("ถังขยะรีไซเคิล ")
                            .font(.noto(isIPad ? 24 : 18, weight: .medium))
                        Text("(สีเหลือง)")
                            .font(.noto(isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
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
                    // ขั้นตอน 1
                    VStack(spacing: 0) {
                        Image("DetailRecycle1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: stepImageSize, height: stepImageSize)
                            .padding(.bottom, 10)

                        Text("เทน้ำให้หมด")
                            .font(.noto(stepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: isIPad ? 60 : 45, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 1
                        VStack(spacing: 2) {
                            Image("bin-icon1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: binIconSize, height: binIconSize)
                            Text("ถังขยะเปียก")
                                .font(.noto(binTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 1
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: arrowSize))
                        .padding(.horizontal, 2)
                        .padding(.top, stepImageSize / 2 - (arrowSize / 2))
                    
                    // ขั้นตอน 2
                    VStack(spacing: 0) {
                        Image("DetailRecycle2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: stepImageSize, height: stepImageSize)
                            .padding(.bottom, 10)
                        
                        Text("แยกฝาและฉลาก")
                            .font(.noto(stepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: isIPad ? 60 : 45, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 2 + 3 ติดกัน
                        HStack(spacing: 5) {
                            VStack(spacing: 2) {
                                Image("bin-icon3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: binIconSize, height: binIconSize)
                                Text("ถังขยะรีไซเคิล")
                                    .font(.noto(binTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            VStack(spacing: 2) {
                                Image("bin-icon2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: binIconSize, height: binIconSize)
                                Text("ถังขยะทั่วไป")
                                    .font(.noto(binTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 2
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: arrowSize))
                        .padding(.horizontal, 2)
                        .padding(.top, stepImageSize / 2 - (arrowSize / 2))
                    
                    // ขั้นตอน 3
                    VStack(spacing: 0) {
                        Image("DetailRecycle3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: stepImageSize, height: stepImageSize)
                            .padding(.bottom, 10)
                        
                        Text("บีบขวดให้แบน")
                            .font(.noto(stepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: isIPad ? 60 : 45, alignment: .top)
                        
                        Spacer().frame(height: 8)
                        
                        // ถัง 4
                        VStack(spacing: 2) {
                            Image("bin-icon3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: binIconSize, height: binIconSize)
                            Text("ถังขยะรีไซเคิล")
                                .font(.noto(binTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, isIPad ? contentPaddingH : 5)
            }
            .padding(.top, 30)
            
            // การรีไซเคิล
            VStack(alignment: .leading, spacing: 10) {
                Text("การรีไซเคิล")
                    .font(.noto(sectionTitleFontSize, weight: .bold))
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
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
