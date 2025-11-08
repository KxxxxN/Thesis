import SwiftUI

struct AccountView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            // ข้อมูลผู้ใช้ (จะต่อ API ทีหลังได้)
            VStack(spacing: 6) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("ชื่อผู้ใช้")
                    .font(.noto(20, weight: .bold))
                
                Text("example@email.com")
                    .font(.noto(16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
            
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
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .ignoresSafeArea()
