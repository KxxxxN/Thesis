//
//  KnowledgeWasteCard.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

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

struct KnowledgeWasteCard: View {
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
