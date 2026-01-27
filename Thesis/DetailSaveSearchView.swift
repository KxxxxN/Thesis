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

                ZStack {
                    Text("ค้นหา")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        
                        Spacer()
                        
                        Button {
                            // 🔹 ใส่ action บันทึกที่นี่
      
                        } label: {
                            Text("บันทึก")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.mainColor)
                                .padding(.trailing, 25)
                        }
                    }
                        
                }
                .padding(.bottom,27)
                
                ScrollView {
                    
                    Image("BarcodeEx")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer().frame(height: 23)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack(spacing: 12) {
                            Text("ขวดพลาสติก")
                                .font(.noto(25, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("13/9/2568 - 13:00")
                                .font(.noto(15, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 8)
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 37)
                        
                        HStack(spacing: 32) {
                            Image("Bin3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("ประเภทถังขยะ")
                                    .font(.noto(20, weight: .bold))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 0) {
                                    Text("ถังขยะรีไซเคิล ")
                                        .font(.noto(18, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text("(สีเหลือง)")
                                        .font(.noto(18, weight: .bold))
                                        .foregroundColor(.recycleWasteColor)
                                }
                            }
                        }
                        
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
                                            .padding(.horizontal, 8)
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
                            .padding(.horizontal, 20)
                            .padding(.top, 25)
                        }
                        .padding(.horizontal, 37)
                        
                        VStack(alignment: .leading, spacing: 9) {
                            Text("การรีไซเคิล")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: -5) {
                                ForEach(recyclingMethods, id: \.self) { method in
                                    Text("•   \(method)")
                                        .font(.noto(18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal, 37)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.knowledgeBackground)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                .edgesIgnoringSafeArea(.bottom)  // ⭐ ให้ยาวจนสุดขอบล่าง
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
    }
}


