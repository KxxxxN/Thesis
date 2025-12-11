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
        NavigationStack {
            VStack(spacing: 0) {
                
                ZStack {
                    Text("ช่วยเหลือ")
                        .font(.noto(25, weight: .bold))
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                
                // Menu List
                VStack(spacing: 0) {
                    
                    // วิธีการใช้งาน
                    HelpMenuRow(
                        title: "วิธีการใช้งาน",
                        imageName: "BookGuide",
                        destination: Text("หน้าวิธีการใช้งาน")
                    )
                    
                    // คำถามที่พบบ่อย
                    HelpMenuRow(
                        title: "คำถามที่พบบ่อย",
                        imageName: "Question",
                        destination: FAQView()
                    )
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
    HelpCenterView()
}
