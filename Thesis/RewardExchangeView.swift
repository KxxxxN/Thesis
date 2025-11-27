//
//  RewardExchangeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//


import SwiftUI

struct RewardExchangeView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    
    let pointsData: [(label: String, value: String, isBold: Bool)] = [
        ("คะแนนทั้งหมด :", "333", false),
        ("ต้องการแลกคะแนน :", "300", true),
        ("คะแนนคงเหลือ :", "33", false)
    ]

    let conditionsList = [
        "ผู้ใช้จะได้รับ คะแนนจากการแยกขยะถูกประเภท \nผ่านระบบสแกนขยะ",
        "คะแนนสามารถใช้ แลกเป็นชั่วโมงจิตอาสา \nของมหาวิทยาลัย",
        "ระบบจะตรวจสอบข้อมูลการแยกขยะจากบัญชีผู้ใช้\nก่อนยืนยันชั่วโมง",
        "ชั่วโมงจิตอาสาที่แลกแล้ว \nไม่สามารถยกเลิกหรือโอนให้ผู้อื่นได้",
        "เฉพาะนักศึกษาของมหาวิทยาลัยเท่านั้น \nที่สามารถแลกได้",
        "การโกงระบบหรือส่งข้อมูลเท็จ จะถูกตัดสิทธิ์ทันที",
        "มหาวิทยาลัยขอสงวนสิทธิ์ในการเปลี่ยนแปลงเงื่อนไข\nโดยไม่ต้องแจ้งล่วงหน้า"
    ]

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Top Bar
            ZStack {
                Color.mainColor
                
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    }

                    Spacer()

                    Text("แลกคะแนน")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 22)
                .padding(.top, 69)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 123)
            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
            
            // MARK: Scroll Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    PointsSummaryCard(pointsData: pointsData)
                        .padding(.top, 41)

                    ConditionsAndExchangeSection(conditionsList: conditionsList)
                }
                .padding(.horizontal, 15)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
    }
}

struct PointsSummaryCard: View {
    let pointsData: [(label: String, value: String, isBold: Bool)]
    
    var body: some View {
        VStack(spacing: -10) {
            ForEach(pointsData.indices, id: \.self) { index in
                HStack {
                    Text(pointsData[index].label)
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, 17)

                    Spacer()

                    Text(pointsData[index].value)
                        .font(.noto(pointsData[index].isBold ? 20 : 18,
                                    weight: pointsData[index].isBold ? .bold : .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, 14)
                }
            }
        }
        .padding(.horizontal, 27)
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.wasteCard)
        .cornerRadius(20)
    }
}

struct ConditionsAndExchangeSection: View {
    let conditionsList: [String]
    
    var body: some View {
        VStack(spacing: 0){
            
            Text("แลกรับชั่วโมงจิตอาสา 1 ชั่วโมง")
                .font(.noto(20, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 42)
                .padding(.top, 34)
                .padding(.bottom, 34)

            VStack(alignment: .leading, spacing: 0) {
                
                VStack {
                    HStack(spacing: 5) {
                        Text("รายละเอียด และเงื่อนไข")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(.black)
                        Text("(จำลอง)")
                            .font(.noto(16, weight: .bold))
                            .foregroundColor(.placeholderColor)
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(conditionsList.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 5) {
                            Text("\(index + 1).")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.black)
                            Text(conditionsList[index])
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.black)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(0)
                        }
                    }
                }
                .padding(.top, 23)
            }
            .padding(32)
            .padding(.vertical, 30)
            .background(Color.wasteCard)
            .frame(maxWidth: .infinity)
            .frame(height: 438)
            .cornerRadius(20)
            
            Button(action: { /* Action */ }) {
                Text("ยืนยันแลกคะแนน")
                    .font(.noto(18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 345, height: 49)
                    .background(Color.mainColor)
                    .cornerRadius(20)
            }
            .padding(.top, 16)
            .padding(.horizontal, 32)
        }
    }
}
