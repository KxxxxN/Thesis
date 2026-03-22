//
//  FAQView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
//    @Environment(\.dismiss) private var dismiss
    
    let cornerRadiusValue: CGFloat = 20
    
    // 💡 Data Source: ข้อมูลคำถามและคำตอบ
    let faqItems: [FAQItem] = [
        FAQItem(question: "สแกนขยะด้วย AI ทำงานอย่างไร",
                answer: "ระบบจะใช้กล้องสแกนขยะ และวิเคราะห์ด้วย AI เพื่อระบุประเภทขยะให้โดยอัตโนมัติ พร้อมแนะนำวิธีทิ้งหรือรีไซเคิลอย่างถูกต้อง"),
        FAQItem(question: "ทำไมบางครั้งระบบแยกขยะผิดพลาด",
                answer: "อาจเกิดจากภาพไม่ชัด แสงน้อย หรือเห็นวัตถุไม่ครบถ้วน แนะนำให้สแกนในที่สว่าง ถือกล้องให้นิ่ง และให้วัตถุอยู่เต็มกรอบภาพ"),
        FAQItem(question: "คะแนนการแยกขยะนำไปใช้ทำอะไรได้",
                answer: "คะแนนสะสมสามารถแลกเป็นชั่วโมงจิตอาสาของมหาวิทยาลัยตามเงื่อนไขที่กำหนด"),
        FAQItem(question: "แก้ไขประวัติการแยกขยะย้อนหลังได้ไหม",
                answer: "ไม่สามารถแก้ไขเองได้เพื่อความถูกต้องของข้อมูล แต่สามารถแจ้งปัญหาผ่านช่องทางการติดต่อที่ระบุภายในแอปได้"),
        FAQItem(question: "แลกคะแนนแล้วขอคืนได้ไหม",
                answer: "ไม่สามารถขอคะแนนที่แลกไปแล้วคืนได้ เพื่อความถูกต้องของระบบ แต่ยังสามารถสะสมคะแนนเพิ่มเติมเพื่อแลกคะแนนครั้งถัดไปได้"),
    ]
    
    var body: some View {
//        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("คำถามที่พบบ่อย")
                        .font(.noto(25, weight: .bold))
                    
                    HStack {
                        BackButton()

                        Spacer()
                    }
                }
                ScrollView {
                    VStack(spacing: 9) {
                        ForEach(faqItems) { item in
                            FAQExpandableRow(item: item)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden(true)
        }
    }
//}

#Preview {
    FAQView()
}
