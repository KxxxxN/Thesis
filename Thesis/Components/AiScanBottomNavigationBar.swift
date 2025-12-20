//
//  AiScanBottomNavigationBar.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI

struct AiScanBottomNavigationBar: View {

    @Binding var selectedTab: Int

    var body: some View {
        ZStack {

            Capsule()
                .fill(Color.secondColor)
                .frame(width: 344, height: 50)

            Capsule()
                .fill(Color.mainColor)
                .frame(width: 110, height: 42)
                .offset(x: CGFloat(selectedTab - 1) * 110)
                .animation(.easeInOut(duration: 0.25), value: selectedTab)

            HStack(spacing: 7) {
                navigationItem(icon: "Barcode", label: "บาร์โค้ด", index: 0)
                navigationItem(icon: "Tabler_ai", label: "สแกน", index: 1)
                navigationItem(icon: "Search", label: "ค้นหา", index: 2)
            }
        }
        .frame(width: 344, height: 50)
    }

    // MARK: - Item
    private func navigationItem(icon: String, label: String, index: Int) -> some View {

        let xOffset: CGFloat = index == 0 ? 6 : (index == 2 ? -6 : 0)

        return Button {
            selectedTab = index
        } label: {
            HStack(spacing: 6) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: icon == "Tabler_ai" ? 37 : 27,
                        height: icon == "Tabler_ai" ? 37 : 27
                    )

                Text(label)
                    .font(.noto(15, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(width: 110, height: 42)
            .offset(x: xOffset)
        }
    }
}

