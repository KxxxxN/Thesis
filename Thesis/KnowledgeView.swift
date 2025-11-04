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

struct KnowledgeView: View {
    @State private var selectedTab = 2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack {
                    Text("ความรู้ทั่วไป")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 65)
                        .padding(.bottom, 24)
                }
                
                // Bin Image Section
                ZStack(alignment: .trailing) {
                    VStack {
                        Image("bin1-photoroom-2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 232)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 32)
                    
                    Button(action: {}) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.mainColor)
                    .clipShape(Circle())
                    .padding(.trailing, 29)
                    .padding(.top, 91)
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("ถังขยะเปียก ")
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(.black)
                        Text("(สีเขียว)")
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(Color.wetWasteColor)
                    }
                    .padding(.bottom, 8)
                    
                    Text("สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ")
                        .font(.noto(20))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    Text("ตัวอย่างขยะ:")
                        .font(.noto(20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 42)
                    
                    // Grid of waste examples
                    WasteExamplesGrid()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 44)
                .padding(.top, 37)
                .padding(.bottom, 113)
                .background(
                    Color.knowledgeBackground
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .ignoresSafeArea(edges: .bottom)
                )
                
                Spacer()
            }
        }
    }
}

struct WasteExamplesGrid: View {
    let wasteExamples = [
        WasteExample(image: "transparent-photoroom--3--2", label: "เศษอาหาร"),
        WasteExample(image: "egg-photoroom-2", label: "เปลือกไข่"),
        WasteExample(image: "fruit-photoroom-1", label: "เปลือกผลไม้"),
        WasteExample(image: "leaf-photoroom-2", label: "ใบไม้"),
        WasteExample(image: "veget3-photoroom-2", label: "เศษผัก"),
        WasteExample(image: "mai-photoroom-2", label: "กิ่งไม้")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 18),
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
                .frame(width: 62, height: 63)
                .frame(width: 80)
            
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
