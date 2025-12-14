struct FrequentWasteCard: View {
    let item: WasteItem

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.noto(14, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.count)
                    .font(.noto(12, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 20)
        }
        .frame(height: 215)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}