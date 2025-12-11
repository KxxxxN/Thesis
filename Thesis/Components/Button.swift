//
//  PrimaryButton.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: - Button Component

//PrimaryButton
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.noto(20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(Color.mainColor)
                .cornerRadius(20)
        }
    }
}

struct SecondButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.noto(20, weight: .bold))
                .foregroundColor(.mainColor)
                .frame(width: width, height: height)
                .background(Color.white)
                .border(Color.mainColor, width: 2)
                .cornerRadius(20)
        }
    }
}
