//
//  ContentView.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

struct MainAppView: View {
    var body: some View {
        VStack(spacing: 0) { // เปิด Vstack1
            VStack(alignment: .leading, spacing: 16) { // เปิด VStack2
                Text("Logo")
                    .font(.custom("Inter UI", size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 69)
                
                HStack(alignment: .center, spacing: 13) { // เปิด HStack1
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                    
                    HStack { // เปิด HStack2
                        Text("สุนิสา จินดาวัฒนา")
                            .fontWeight(.bold)
                            .font(.custom("Inter UI", size: 20))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {// เปิด VStack3
                            Text("333")
                                .font(.custom("Inter UI", size: 40))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text("คะแนน")
                                .font(.custom("Inter UI", size: 15))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }// ปิด VStack3
                    } // ปิด HStack2
                    .padding(.trailing, 28)
                } // ปิด HStack1
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, alignment: .leading)
            } // ปิด VStack2
            .frame(maxWidth: .infinity, minHeight: 205, alignment: .leading)
            .padding(.leading, 28)
            .background(Color.mainColor)
            .clipShape(
                RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight])
            )
            
            Spacer()
        } // ปิด Vstack1
        .frame(maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.bottomLeft, .bottomRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainAppView()
}
