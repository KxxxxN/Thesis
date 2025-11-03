struct HistorySection: View {
    let items: [HistoryItem]
    
    var body: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "ประวัติคะแนน")
            
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.custom("Inter", size: 20).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text(item.date)
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text(item.points)
                            .font(.custom("Inter", size: 25).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text(item.pointsLabel)
                            .font(.custom("Inter", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
                .background(Color(hex: "768572"))
                .cornerRadius(20)
            }
        }
    }
}