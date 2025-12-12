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

//SecondButton
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
                .background(Color.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mainColor, lineWidth: 2)
                )
        }
    }
}

//BackButton
struct BackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 24, weight: .bold))
        }
        .padding(.leading, 25)
    }
}
