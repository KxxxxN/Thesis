//
//  HelpCenterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                Text("ช่วยเหลือ")
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
            
            VStack(spacing: 0) {
                
                Button(action: {
                    print("Thai")
                }) {
                    HStack(spacing: 15) {
                        Image("BookGuide")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 32)
                        
                        Text("วิธีการใช้งาน")
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
                
                Button(action: {
                    print("English")
                }) {
                    HStack(spacing: 15) {
                        Image("Question")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 32)
                        
                        Text("คำถามที่พบบ่อย")
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
            .padding(.top, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HelpCenterView()
}
