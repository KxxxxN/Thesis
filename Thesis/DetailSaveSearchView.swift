//
//  DetailSaveSearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 12/1/2569 BE.
//


import SwiftUI

struct DetailSaveSearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool

    let separationSteps = [
        SeparationStep(imageName: "DetailRecycle1", text: "เทน้ำให้หมด", imageSize: CGSize(width: 100, height: 100)),
        SeparationStep(imageName: "DetailRecycle2", text: "เอาฝาและฉลากออก", imageSize: CGSize(width: 120, height: 120)),
        SeparationStep(imageName: "DetailRecycle3", text: "บีบขวดให้แบน", imageSize: CGSize(width: 100, height: 100))
    ]

    let recyclingMethods = [
        "ใช้เป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่ปากกา",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    let plasticbottleStep = [
        PlasticbottleStep(imageName: "bin-icon1", text: "ถังขยะเปียก", imageSize: CGSize(width: 40, height: 40)),
        PlasticbottleStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล", imageSize: CGSize(width: 40, height: 40)),
        PlasticbottleStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป", imageSize: CGSize(width: 40, height: 40)),
        PlasticbottleStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล", imageSize: CGSize(width: 40, height: 40))
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Section
                ZStack {
                    Text("ค้นหา")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                        Button {
                            // Action บันทึก
                        } label: {
                            Text("บันทึก")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.mainColor)
                                .padding(.trailing, 25)
                        }
                    }
                }
                .padding(.bottom, 20)

                // MARK: - Content Section
                ScrollView {
                    VStack(spacing: 0) {
                        // 1. รูปภาพสินค้า (อยู่นอกพื้นที่สีครีมเพื่อให้เห็นพื้นหลังสีเขียวข้างหลัง)
                        Image("BarcodeEx")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.bottom, 30) // ระยะห่างก่อนถึงขอบโค้ง
                        
                        // 2. พื้นที่เนื้อหาที่มีพื้นหลังสีครีมและขอบโค้ง
                        VStack(alignment: .leading, spacing: 0) {
                            
                            // ชื่อขยะและวันที่
                            HStack(spacing: 12) {
                                Text("ขวดพลาสติก")
                                    .font(.noto(25, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("13/9/2568 - 13:00")
                                    .font(.noto(15, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(.top, 8)
                            }
                            .padding(.top, 30)
                            .padding(.horizontal, 37)

                            
                            // ประเภทถังขยะ
                            HStack(spacing: 32) {
                                Image("Bin3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180, height: 180)
                                
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
                            .padding(.top, 10)
                            
                            // วิธีการแยกขยะ
                            VStack(alignment: .leading, spacing: -10) {
                                Text("วิธีการแยกขยะ")
                                    .font(.noto(20, weight: .bold))
                                    .foregroundColor(.black)

                                
                                HStack(spacing: 0) {
                                    ForEach(separationSteps.indices, id: \.self) { index in
                                        
                                        if index > 0 {
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(.black)
                                                .font(.system(size: 20))
                                                .padding(.horizontal, 2)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            ZStack {
                                                Color.clear
                                                    .frame(width: 90, height: 90)
                                                    .background(Color.clear)
                                                
                                                Image(separationSteps[index].imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(
                                                        width: separationSteps[index].imageSize.width,
                                                        height: separationSteps[index].imageSize.height
                                                    )
                                            }
                                            
                                            Text(separationSteps[index].text)
                                                .font(.noto(15, weight: .medium))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(width: 100)
                                        }
                                    }
                                }
                                
                                HStack (spacing: 35){
                                    ForEach(plasticbottleStep.indices, id: \.self) { index in
                                        VStack(spacing: 4) {
                                            Image(plasticbottleStep[index].imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(
                                                    width: plasticbottleStep[index].imageSize.width,
                                                    height: plasticbottleStep[index].imageSize.height
                                                )

                                            Text(plasticbottleStep[index].text)
                                                .font(.noto(12, weight: .medium))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding(.top, 25)
                                .padding(.horizontal, 10)

                            }
                            .padding(.horizontal, 37)
                            .padding(.top, 25)
                            
                            // การรีไซเคิล
                            VStack(alignment: .leading, spacing: 10) {
                                Text("การรีไซเคิล")
                                    .font(.noto(20, weight: .bold))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(recyclingMethods, id: \.self) { method in
                                        Text("•   \(method)")
                                            .font(.noto(17, weight: .medium))
                                    }
                                }
                            }
                            .padding(.horizontal, 37)
                            .padding(.top, 30)
                            .padding(.bottom, 50)
                            
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Color.knowledgeBackground
                                .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                        )                    }
                    // กำหนดความสูงเริ่มต้นให้เนื้อหาส่วนล่างเพื่อให้ ScrollView คำนวณพื้นที่ได้
                    .frame(minHeight: 750)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
    }
}
