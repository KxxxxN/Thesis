//
//  HelpMenuRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct HelpMenuRow<Destination: View>: View {
    let title: String
    let imageName: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                Image(imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 32)
                
                Text(title)
                    .font(.noto(20, weight: .medium))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold))
            }
            .padding(.trailing)
            .frame(height: 93)
            .background(Color.accountSecColor)
        }
    }
}
