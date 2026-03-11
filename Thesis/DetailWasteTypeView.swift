//
//  DetailWasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct DetailWasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    let category: String
    
    private func imageForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก":  return "TypeBottle"
        case "แก้วพลาสติก":  return "TypePlasticCup"
        case "กระป๋อง":      return "TypeCan"
        case "กล่องกระดาษ":  return "TypeCardboard"
        case "กระดาษทั่วไป": return "TypePaper"
        case "ถุงพลาสติก":   return "TypePlasticBag"
        default:             return "TypeBottle2"
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {

                ZStack {
                    Text("ประเภทขยะ")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.bottom,27)
                
                ScrollView {
                    
                    Image(imageForCategory(category))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer().frame(height: 23)
                    
                    // ✅ แสดง component ตาม category
                    switch category {
                    case "ขวดพลาสติก":  RecycleWasteDetailPlasticBottle()
                    case "แก้วพลาสติก":  RecycleWasteDetailPlasticCup()
                    case "กระป๋อง":      RecycleWasteDetailCan()
                    case "กล่องกระดาษ":  RecycleWasteDetailCardboardBox()
                    case "กระดาษทั่วไป": RecycleWasteDetailPaper()
                    case "ถุงพลาสติก":   RecycleWasteDetailPlasticBag()
                    default:
                        Text("ไม่พบข้อมูลประเภทขยะนี้")
                            .font(.noto(18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .edgesIgnoringSafeArea(.bottom)  // ⭐ ให้ยาวจนสุดขอบล่าง
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
    }
}


