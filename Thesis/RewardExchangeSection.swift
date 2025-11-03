struct RewardExchangeSection: View {
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "แลกคะแนน")
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("300")
                            .font(.custom("Inter", size: 25).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text("คะแนน")
                            .font(.custom("Inter", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("แลกชั่วโมงจิตอาสาได้ 1 ชั่วโมง")
                        .font(.custom("Inter", size: 14).weight(.medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("แลกคะแนน")
                        .font(.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(hex: "3b5131"))
                        .cornerRadius(20)
                }
            }
            .padding(16)
            .background(Color(hex: "768572"))
            .cornerRadius(20)
        }
    }
}