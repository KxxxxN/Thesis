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

struct NavItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let index: Int
}

struct KnowledgeView: View {
    @State private var selectedTab = 2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "f4f5f7")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack {
                    Text("ความรู้ทั่วไป")
                        .font(.system(size: 25, weight: .bold))
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
                    .background(Color(hex: "3b5131"))
                    .clipShape(Circle())
                    .padding(.trailing, 29)
                    .padding(.top, 91)
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("ถังขยะเปียก ")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                        Text("(สีเขียว)")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(hex: "009345"))
                    }
                    .padding(.bottom, 8)
                    
                    Text("สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    Text("ตัวอย่างขยะ:")
                        .font(.system(size: 20, weight: .bold))
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
                    Color(hex: "e8e6e2")
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .ignoresSafeArea(edges: .bottom)
                )
                
                Spacer()
            }
            
            // Bottom Navigation
            BottomNavigationBar(selectedTab: $selectedTab)
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
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
        }
        .frame(height: 85)
        .background(Color(hex: "d9d5cf"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    
    let navItems = [
        NavItem(icon: "house", label: "หน้าหลัก", index: 0),
        NavItem(icon: "qrcode.viewfinder", label: "สแกน", index: 1),
        NavItem(icon: "book", label: "ความรู้ทั่วไป", index: 2),
        NavItem(icon: "person", label: "บัญชีผู้ใช้", index: 3)
    ]
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(navItems) { item in
                    if item.index == 2 {
                        Spacer()
                            .frame(width: 70)
                    } else {
                        Button(action: {
                            selectedTab = item.index
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 37))
                                    .foregroundColor(.white)
                                Text(item.label)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 88)
            .background(Color(hex: "3b5131"))
            
            // Center elevated button
            VStack(spacing: 4) {
                Button(action: {
                    selectedTab = 2
                }) {
                    Image(systemName: "book")
                        .font(.system(size: 37))
                        .foregroundColor(Color(hex: "121810"))
                }
                .frame(width: 70, height: 70)
                .background(Color(hex: "f4f5f7"))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(Color(hex: "121810"), lineWidth: 7)
                )
                .offset(y: -18)
                
                Text("ความรู้ทั่วไป")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .offset(y: -18)
            }
        }
        .frame(maxWidth: 440)
    }
}
