//
//  ContactUsView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ContactUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                ZStack {
                    Text("ติดต่อเรา")
                        .font(.noto(25, weight: .bold))
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .font(.system(size: 24, weight: .bold))
                        }
                        .padding(.leading, 25)
                        Spacer()
                    }
                }
                
                // Menu List
                VStack(spacing: 0) {
                    ContactRow(
                        title: "ช่องทางที่ 1",
                        imageName: "ContactUs"
                    ) {
                        print("ติดต่อ 1")
                    }
                    
                    ContactRow(
                        title: "ช่องทางที่ 2",
                        imageName: "ContactUs"
                    ) {
                        print("ติดต่อ 2")
                    }
                }
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContactUsView()
}
