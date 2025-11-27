//
//  DetailView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct DetailView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool

    let separationSteps = [
        SeparationStep(imageName: "DetailRecycle1", text: "เทน้ำให้หมด", imageSize: CGSize(width: 40, height: 88)),
        SeparationStep(imageName: "DetailRecycle2", text: "เอาฝาและฉลากออก", imageSize: CGSize(width: 78, height: 63)),
        SeparationStep(imageName: "DetailRecycle3", text: "บีบขวดให้แบน", imageSize: CGSize(width: 43, height: 72))
    ]
    
    let recyclingMethods = [
        "ใช้เป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่ปากกา",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {

                ZStack {
                    Text("รายละเอียด")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        Button(action: {
                            hideTabBar = false
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                }
                .padding(.top, 5)
                .padding(.bottom,27)
                
                ScrollView {
                    
                    Image("TypeBottle1")
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
                                .frame(width: 68, height: 107)
                            
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
                        .padding(.horizontal, 58)
                        .padding(.top, 23)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            Text("วิธีการแยกขยะ")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0) {
                                ForEach(separationSteps.indices, id: \.self) { index in
                                    
                                    if index > 0 {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                            .padding(.horizontal, 8)
                                            .padding(.top, 40)
                                    }
                                    
                                    VStack(spacing: 20) {
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
                        }
                        .padding(.horizontal, 37)
                        .padding(.top, 29)
                        
                        VStack(alignment: .leading, spacing: 9) {
                            Text("การรีไซเคิล")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(recyclingMethods, id: \.self) { method in
                                    Text("• \(method)")
                                        .font(.noto(18, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal, 37)
                        .padding(.top, 34)
                        .padding(.bottom, 40)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.knowledgeBackground)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
    }
}

struct SeparationStep {
    let imageName: String
    let text: String
    let imageSize: CGSize
}
