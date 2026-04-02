//
//  KnowledgeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 27/10/2568 BE.
//

import SwiftUI
import Foundation

struct KnowledgeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var currentIndex = 0
    @Binding var hideTabBar: Bool
    
    // MARK: - Responsive Dimensions
    private var isIPad: Bool { horizontalSizeClass == .regular }
    
    // ปรับ Padding ด้านบนให้เหมาะสมขึ้น
    private var titleTopPadding: CGFloat { isIPad ? 80 : 65 }
    private var titleFont: CGFloat { isIPad ? 36 : 25 }
    
    private var binImageSize: CGFloat { isIPad ? 350 : 235 }
    private var binPaddingBottom: CGFloat { isIPad ? 40 : 20 }
    
    private var arrowButtonSize: CGFloat { isIPad ? 70 : 50 }
    private var arrowIconSize: CGFloat { isIPad ? 40 : 30 }
    private var arrowSidePadding: CGFloat { isIPad ? 60 : 29 }
    
    private var contentPaddingH: CGFloat { isIPad ? 60 : 35 }
    private var contentPaddingTop: CGFloat { isIPad ? 40 : 28 }
    
    private var headerFont: CGFloat { isIPad ? 36 : 25 }
    private var descFont: CGFloat { isIPad ? 26 : 20 }
    private var descHeight: CGFloat { isIPad ? 80 : 55 }
    
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
                WasteExample(image: "Drink", label: "เครื่องดื่มเหลือ"),
                WasteExample(image: "Snack", label: "เศษขนม"),
                WasteExample(image: "Ice", label:"น้ำแข็งเหลือ")
            ]
        ),
        WasteCategory(
            name: "ถังขยะทั่วไป",
            colorName: "(สีน้ำเงิน)",
            color: .generalWasteColor,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "SnackBag", label: "ซองขนม"),
                WasteExample(image: "Tissue", label: "กระดาษทิชชู่"),
                WasteExample(image: "Foambox", label: "ภาชนะใส่อาหาร"),
                WasteExample(image: "Chopstick", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Spoon", label: "ช้อน-ส้อมพลาสติก")
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
                WasteExample(image: "paper", label: "กระดาษทั่วไป"),
                WasteExample(image: "Can", label: "กระป๋อง"),
                WasteExample(image: "Bag", label: "ถุงพลาสติก")
            ]
        ),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                Color.backgroundColor
                    .ignoresSafeArea()
                
                // ใช้ GeometryReader เพื่ออ่านค่าความสูงและความกว้างของหน้าจอ
                GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            Text("ความรู้ทั่วไป")
                                .font(.noto(titleFont, weight: .bold))
                                .minimumScaleFactor(0.7)
                                .foregroundColor(.black)
                                .padding(.top, titleTopPadding)
                                .padding(.bottom, 10)
                            
                            let current = wasteCategories[currentIndex]
                            
                            // ส่วนแสดงถังขยะและปุ่มลูกศร
                            ZStack {
                                Image(current.binImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: binImageSize, height: binImageSize)
                                    .padding(.bottom, binPaddingBottom)
                                
                                // ปุ่มลูกศร
                                HStack {
                                    // ปุ่มซ้าย
                                    if currentIndex > 0 {
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                currentIndex -= 1
                                            }
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: arrowIconSize))
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: arrowButtonSize, height: arrowButtonSize)
                                        .background(Color.mainColor)
                                        .clipShape(Circle())
                                        .padding(.leading, arrowSidePadding)
                                    } else {
                                        Color.clear
                                            .frame(width: arrowButtonSize, height: arrowButtonSize)
                                            .padding(.leading, arrowSidePadding)
                                    }
                                    
                                    Spacer()
                                    
                                    // ปุ่มขวา
                                    if currentIndex < wasteCategories.count - 1 {
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                currentIndex += 1
                                            }
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: arrowIconSize))
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: arrowButtonSize, height: arrowButtonSize)
                                        .background(Color.mainColor)
                                        .clipShape(Circle())
                                        .padding(.trailing, arrowSidePadding)
                                        
                                    } else {
                                        Color.clear
                                            .frame(width: arrowButtonSize, height: arrowButtonSize)
                                            .padding(.trailing, arrowSidePadding)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // ส่วนข้อมูลและตัวอย่างขยะ
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(current.name + " ")
                                        .font(.noto(headerFont, weight: .bold))
                                        .minimumScaleFactor(0.8)
                                        .foregroundColor(.black)
                                    Text(current.colorName)
                                        .font(.noto(headerFont, weight: .bold))
                                        .minimumScaleFactor(0.8)
                                        .foregroundColor(current.color)
                                }
                                .padding(.bottom, 5)
                                
                                Text(current.description)
                                    .font(.noto(descFont, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(minHeight: descHeight, maxHeight: descHeight, alignment: .top)
                                    .padding(.bottom, 10)
                                
                                Text("ตัวอย่างขยะ:")
                                    .font(.noto(descFont, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                                
                                WasteExamplesGrid(hideTabBar: $hideTabBar, wasteExamples: current.examples)
                                
                                Spacer(minLength: 50)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.horizontal, contentPaddingH)
                            .padding(.top, contentPaddingTop)
                            .background(
                                Color.knowledgeBackground
                                    .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                                    .ignoresSafeArea(.container, edges: .horizontal)
                            )
                        }
                        // บังคับความกว้าง (width) ให้เท่ากับหน้าจอเสมอ เพื่อไม่ให้กล่องหดตัวในแนวนอน
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height, alignment: .top)
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            hideTabBar = false
        }
    }
}

struct WasteExamplesGrid: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    
    private var isIPad: Bool { horizontalSizeClass == .regular }
    
    private var columns: [GridItem] {
        if isIPad {
            return [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20),
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 18)
            ]
        }
    }
    
    private var gridSpacing: CGFloat { isIPad ? 20 : 10 }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: gridSpacing) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    DetailWasteTypeView(hideTabBar: $hideTabBar, category: example.label)
                } label: {
                    WasteCard(example: example)
                }
            }
        }
    }
}

struct WasteCard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let example: WasteExample
    
    private var isIPad: Bool { horizontalSizeClass == .regular }
    
    private var imageSize: CGFloat { isIPad ? 80 : 60 }
    private var textFont: CGFloat { isIPad ? 22 : 16 }
    private var cardHeight: CGFloat { isIPad ? 110 : 85 }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(example.image)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .frame(width: imageSize) // ล็อกขอบเขตภาพ
                .padding(10)
                
            Text(example.label)
                .font(.noto(textFont, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10)
        }
        .frame(height: cardHeight)
        .background(Color.wasteCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview{
    KnowledgeView(hideTabBar: .constant(false))
}
