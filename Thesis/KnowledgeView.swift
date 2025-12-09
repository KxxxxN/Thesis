//
//  KnowledgeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 27/10/2568 BE.
//

import SwiftUI
import Foundation

struct WasteExample: Identifiable {
    let id = UUID()
    let image: String
    let label: String
}

struct WasteCategory {
    let name: String
    let colorName: String
    let color: Color
    let description: String
    let binImage: String
    let examples: [WasteExample]
}

struct KnowledgeView: View {
    @State private var currentIndex = 0
    @Binding var hideTabBar: Bool
    
    let wasteCategories: [WasteCategory] = [
        WasteCategory(
            name: "ถังขยะเปียก",
            colorName: "(สีเขียว)",
            color: .wetWasteColor,
            description: "สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ",
            binImage: "Bin1",
            examples: [
                WasteExample(image: "Foodscraps", label: "เศษอาหาร"),
                WasteExample(image: "Egg", label: "เปลือกไข่"),
                WasteExample(image: "Fruit", label: "เปลือกผลไม้"),
                WasteExample(image: "Leaf", label: "ใบไม้"),
                WasteExample(image: "Veget", label: "เศษผัก"),
                WasteExample(image: "Stick", label:"กิ่งไม้")
            ]
        ),
        WasteCategory(
            name: "ถังขยะทั่วไป",
            colorName: "(สีน้ำเงิน)",
            color: .generalWasteColor,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "Chips", label: "ซองขนม"),
                WasteExample(image: "Tissue", label: "กระดาษทิชชู่"),
                WasteExample(image: "Foambox", label: "กล่องโฟม"),
                WasteExample(image: "Chopstick", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Spoon", label: "ช้อน-ส้อม พลาสติก")
            ]
        ),
        WasteCategory(
            name: "ถังขยะรีไซเคิล",
            colorName: "(สีเหลือง)",
            color: .recycleWasteColor,
            description: "สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือแปรรูปได้",
            binImage: "Bin3",
            examples: [
                WasteExample(image: "Bottle", label: "ขวดพลาสติก"),
                WasteExample(image: "Box", label: "กล่องกระดาษ"),
                WasteExample(image: "Plasticcup", label: "แก้วพลาสติก"),
                WasteExample(image: "Glassbottle", label: "ขวดแก้ว"),
                WasteExample(image: "Can", label: "กระป๋อง"),
                WasteExample(image: "Bag", label: "ถุงพลาสติก")
            ]
        ),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Text("ความรู้ทั่วไป")
                            .font(.noto(25, weight: .bold))
                            .minimumScaleFactor(0.7)
                            .foregroundColor(.black)
                            .padding(.top, 65)
                            .padding(.bottom, 10)
                        
                        let current = wasteCategories[currentIndex]
                        
                        ZStack {
                            Image(current.binImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 152, height: 235)
                                .padding(.bottom, 20)
                            
                            // ปุ่มลูกศร
                            HStack {
                                // ปุ่มซ้าย
                                if currentIndex > 0 { // ใช้ currentIndex > 0 แทน == 1 || == 2 เพื่อให้ครอบคลุมกรณีที่มีถังขยะมากกว่า 3 ถัง
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            currentIndex -= 1
                                        }
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 50, height: 50)
                                    .background(Color.mainColor)
                                    .clipShape(Circle())
                                    .padding(.leading, 29)
                                } else {
                                    Color.clear
                                        .frame(width: 50, height: 50)
                                        .padding(.leading, 29)
                                }
                                
                                Spacer()
                                
                                // ปุ่มขวา
                                if currentIndex < wasteCategories.count - 1 { // ใช้ currentIndex < count - 1 เพื่อให้ครอบคลุมถังขยะทั้งหมด
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            currentIndex += 1
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 50, height: 50)
                                    .background(Color.mainColor)
                                    .clipShape(Circle())
                                    .padding(.trailing, 29)
                                    
                                } else {
                                    Color.clear
                                        .frame(width: 50, height: 50)
                                        .padding(.trailing, 29)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Text(current.name + " ")
                                    .font(.noto(25, weight: .bold))
                                    .minimumScaleFactor(0.8)
                                    .foregroundColor(.black)
                                Text(current.colorName)
                                    .font(.noto(25, weight: .bold))
                                    .minimumScaleFactor(0.8)
                                    .foregroundColor(current.color)
                            }
                            .padding(.bottom, 5)

                            
                            Text(current.description)
                                .font(.noto(20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minHeight: 55, maxHeight: 55, alignment: .top)
                                .padding(.bottom, 10)
                            
                            Text("ตัวอย่างขยะ:")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            
                            WasteExamplesGrid(hideTabBar: $hideTabBar, wasteExamples: current.examples)

                            Color.clear.frame(height: 40)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 35)
                        .padding(.top, 28)
                        .background(
                            Color.knowledgeBackground
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .ignoresSafeArea(edges: .bottom)
                        )
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct WasteExamplesGrid: View {
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    DetailWasteTypeView(hideTabBar: $hideTabBar)
                } label: {
                    WasteCard(example: example)
                }
            }
        }
    }
}



struct WasteCard: View {
    let example: WasteExample
    
    var body: some View {
        HStack(spacing: 0) {
            Image(example.image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .frame(width: 60)
                .padding(10)
                
            Text(example.label)
                .font(.noto(16, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10)
        }
        .frame(height: 85)
        .background(Color.wasteCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

