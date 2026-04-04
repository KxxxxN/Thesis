//
//  DetailWasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct DetailWasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    let category: String
    
    // MARK: - Responsive Dimensions
    private var isIPad: Bool { horizontalSizeClass == .regular }
    
    private var titleTopPadding: CGFloat { isIPad ? 80 : 65 }
    private var titleFontSize: CGFloat { isIPad ? 36 : 25 }
    private var titlePaddingBottom: CGFloat { isIPad ? 40 : 27 }
    private var contentPaddingH: CGFloat { isIPad ? 60 : 20 } // ระยะห่างซ้ายขวา
    private var imageHeight: CGFloat { isIPad ? 450 : 290 } // ความสูงของรูปภาพ
    private var spacingAfterImage: CGFloat { isIPad ? 40 : 23 }
    
    private func imageForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก":  return "TypeBottle"
        case "แก้วพลาสติก":  return "TypePlasticCup"
        case "กระป๋อง":      return "TypeCan"
        case "กล่องกระดาษ":  return "TypeCardboard"
        case "กระดาษทั่วไป": return "TypePaper"
        case "ถุงพลาสติก":   return "TypePlasticBag"
        case "เศษอาหาร":  return "TypeFood"
        case "เปลือกผลไม้":  return "TypeFruit"
        case "เศษขนม":      return "TypeSnack"
        case "เปลือกไข่":  return "TypeEgg"
        case "เครื่องดื่มเหลือ": return "TypeDrink"
        case "น้ำแข็งเหลือ":   return "TypeIce"
        case "ซองขนม": return "TypeSnackBag"
        case "ภาชนะใส่อาหาร": return "TypeContainer"
        case "หลอด": return "TypeStraw"
        case "กระดาษทิชชู่": return "TypeTissue"
        case "ตะเกียบไม้": return "TypeChopstick"
        case "ช้อน-ส้อมพลาสติก": return "TypeSpoon"
        default:             return "TypeBottle2"
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {

                // ส่วน Header (ชื่อหน้า + ปุ่ม Back)
                ZStack {
                    Text("ประเภทขยะ")
                        .font(.noto(titleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.horizontal, contentPaddingH) // ใช้ Padding แทนขอบแข็ง
                .padding(.bottom, titlePaddingBottom)
                .padding(.top, titleTopPadding)

                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        Image(imageForCategory(category))
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity) // ให้กว้างสุดเท่าที่ทำได้
                            .frame(height: imageHeight) // ล็อกความสูงตามขนาดจอ
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal, contentPaddingH) // บีบขอบซ้ายขวา
                        
                        Spacer().frame(height: spacingAfterImage)
                        
                        // ✅ แสดง component ตาม category
                        switch category {
                        case "ขวดพลาสติก":  RecycleWasteDetailPlasticBottle()
                        case "แก้วพลาสติก":  RecycleWasteDetailPlasticCup()
                        case "กระป๋อง":      RecycleWasteDetailCan()
                        case "กล่องกระดาษ":  RecycleWasteDetailCardboardBox()
                        case "กระดาษทั่วไป": RecycleWasteDetailPaper()
                        case "ถุงพลาสติก":   RecycleWasteDetailPlasticBag()
                        case "เศษอาหาร":  WetWasteDetailFoodscraps()
                        case "เปลือกผลไม้":  WetWasteDetailFruitPeel()
                        case "เศษขนม":      WetWasteDetailCrumbs()
                        case "เปลือกไข่":  WetWasteDetailEggshell()
                        case "เครื่องดื่มเหลือ": WetWasteDetailLeftoverDrinks()
                        case "น้ำแข็งเหลือ":   WetWasteDetailLeftoverIce()
                        case "ซองขนม": GeneralWasteDetailSnackBag()
                        case "ภาชนะใส่อาหาร": GeneralWasteDetailFoodContainer()
                        case "หลอด": GeneralWasteDetailStraw()
                        case "กระดาษทิชชู่": GeneralWasteDetailTissue()
                        case "ตะเกียบไม้": GeneralWasteDetailChopsticks()
                        case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon()
                            
                        default:
                            Text("ไม่พบข้อมูลประเภทขยะนี้")
                                .font(.noto(18, weight: .medium))
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)  // ⭐ ให้ยาวจนสุดขอบล่าง
            }
            .ignoresSafeArea(.container, edges: .top)

        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
        }
    }
}
