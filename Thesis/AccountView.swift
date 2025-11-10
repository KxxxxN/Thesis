//
//  AccountView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        
         Spacer()
        // ปุ่มออกจากระบบ
        Button(action: {
            isLoggedIn = false
        }) {
            Text("ออกจากระบบ")
                .font(.noto(18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.mainColor)
                .cornerRadius(15)
        }
        
        Spacer()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    AccountView()
}
