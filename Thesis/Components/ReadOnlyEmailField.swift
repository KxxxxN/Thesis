//
//  ReadOnlyEmailField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/2/2569 BE.
//


import SwiftUI

struct ReadOnlyEmailField: View {
    let title: String
    let email: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Title(title: title)
            
            HStack {
                Text(email)
                    .font(.noto(17, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.leading, 15)
                Spacer()
                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.placeholderColor)
                    .padding(.trailing, 15)
            }
            .frame(width: 345, height: 49)
            .background(Color.textFieldColor)
            .cornerRadius(20)
            .opacity(0.6)
        }
    }
}
