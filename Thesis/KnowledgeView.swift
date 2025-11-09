//
//  KnowledgeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 27/10/2568 BE.
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
            colorName: "(สีเทา)",
            color: Color.gray,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "Chips", label: "ซองขนม"),
                WasteExample(image: "Tissue", label: "กระดาษทิชชู่"),
                WasteExample(image: "Foambox", label: "กล่องโฟม"),
                WasteExample(image: "Chopstick", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Spoon", label: "ช้อน-ส้อม พลาสติก")
            ]
        ),
        WasteCategory(
            name: "ถังขยะรีไซเคิล",
            colorName: "(สีเหลือง)",
            color: Color.yellow,
            description: "สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือ\nแปรรูปได้",
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
        ZStack(alignment: .bottom) {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("ความรู้ทั่วไป")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 65)
                    .padding(.bottom, 24)
                
                let current = wasteCategories[currentIndex]
                
                ZStack {
                    Image(current.binImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 232)
                        .padding(.bottom, 32)
                    
                    // ปุ่มลูกศร
                    HStack {
                        //แสดงปุ่มซ้ายเฉพาะตอนเป็นถังขยะทั่วไปหรือรีไซเคิล
                        if currentIndex == 1 || currentIndex == 2 {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    currentIndex = (currentIndex - 1 + wasteCategories.count) % wasteCategories.count
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
                            .padding(.top, 91)
                        } else {
                            Color.clear
                                .frame(width: 50, height: 50)
                                .padding(.leading, 29)
                                .padding(.top, 91)
                        }
                        
                        Spacer()
                        
                        if currentIndex == 0 || currentIndex == 1 {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    currentIndex = (currentIndex + 1) % wasteCategories.count
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
                            .padding(.top, 91)
                        } else {
                            Color.clear
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 29)
                                .padding(.top, 91)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(current.name + " ")
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(.black)
                        Text(current.colorName)
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(current.color)
                    }
                    .padding(.bottom, 8)
                    
                    Text(current.description)
                        .font(.noto(18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 20)

                    
                    Text("ตัวอย่างขยะ:")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    WasteExamplesGrid(wasteExamples: current.examples)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 35)
                .padding(.top, 37)
                .padding(.bottom, 113)
                .background(
                    Color.knowledgeBackground
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
}

struct WasteExamplesGrid: View {
    let wasteExamples: [WasteExample]
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(wasteExamples) { example in
                WasteCard(example: example)
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
                .frame(width: 60, height: 63)
                .frame(width: 70)
            
            Text(example.label)
                .font(.noto(16, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
        }
        .frame(height: 85)
        .background(Color.wasteCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    KnowledgeView()
}
