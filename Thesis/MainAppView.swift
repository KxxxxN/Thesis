//
//  MainAppView.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentCarouselIndex = 0
    @Binding var hideTabBar: Bool
    @Binding var tabIndex: Int
    @StateObject private var profileVM = UserProfileViewModel()
    @StateObject private var wasteVM = FrequentWasteViewModel()

    // 1. ตรวจสอบ Size Class
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        GeometryReader { geo in
            // 2. คำนวณค่าตัวแปรตามขนาดหน้าจอ
            let isIPad = horizontalSizeClass == .regular
            let screenWidth = geo.size.width
            
            let horizontalPadding: CGFloat = isIPad ? 40 : 28
            let nameFontSize: CGFloat = isIPad ? 30 : 20
            let pointsFontSize: CGFloat = isIPad ? 60 : 40
            let logoWidth: CGFloat = isIPad ? 150 : 110
            let logoHeight: CGFloat = isIPad ? 60 : 44
            let profileSize: CGFloat = isIPad ? 80 : 55
            let headerHeight: CGFloat = isIPad ? 260 : 205

            VStack(spacing: 0) {
                // --- Header Section ---
                VStack(alignment: .leading, spacing: 4) {
                    Image("logo_white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoWidth, height: logoHeight)
                        .padding(.top, isIPad ? 60 : 80)
                    
                    HStack(alignment: .center, spacing: 13) {
                        Group {
                            if let image = profileVM.profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Image("Profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .frame(width: profileSize, height: profileSize)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        
                        HStack {
                            if profileVM.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(profileVM.fullName)
                                    .font(.noto(nameFontSize, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(profileVM.totalPoints)")
                                    .font(.system(size: pointsFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("คะแนน")
                                    .font(.noto(isIPad ? 20 : 15, weight: .regular))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.trailing, horizontalPadding)
                    }
                    .padding(.bottom, isIPad ? 40 : 36)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: headerHeight)
                .frame(maxWidth: .infinity)
                .padding(.leading, horizontalPadding)
                .background(Color.mainColor)
                .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
                
                // --- Scrollable Content ---
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: isIPad ? 30 : 20) {
                        HistorySection(
                            hideTabBar: $hideTabBar,
                            items: profileVM.latestHistory.map { [$0] } ?? []
                        )
                        
                        RewardExchangeSection(hideTabBar: $hideTabBar)
                        
                        FrequentWasteSection(
                            hideTabBar: $hideTabBar,
                            items: wasteVM.wasteItems.isEmpty
                                ? [
                                    RecyclableItem(imageName: "Bottle",     title: "ขวดพลาสติก", countNumber: 0),
                                    RecyclableItem(imageName: "Plasticcup",        title: "แก้วพลาสติก",    countNumber: 0),
                                    RecyclableItem(imageName: "Can",        title: "กระป๋อง",    countNumber: 0)
                                  ]
                                : wasteVM.wasteItems.prefix(3).map {
                                    RecyclableItem(
                                        imageName: $0.imageName,
                                        title: $0.title,
                                        countNumber: Int($0.count.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
                                    )
                                  }
                        )
                        
                        WasteSeparationGuideSection(currentIndex: $currentCarouselIndex, hideTabBar: $hideTabBar, tabIndex: $tabIndex)
                    }
                    .padding()
                    .padding(.horizontal, isIPad ? 20 : 0)
                    .frame(maxWidth: isIPad ? 1100 : .infinity, alignment: .center) // จำกัดความกว้างบน iPad
                }
                .frame(width: screenWidth) // ให้ ScrollView กว้างเต็มจอเพื่อจัดกึ่งกลางเนื้อหาด้านใน
                
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .task {
                do {
                    let session = try await supabase.auth.session
                    await profileVM.fetchProfile(userId: session.user.id)
                    await wasteVM.fetchWasteCounts()
                } catch {
                    print("❌ No session: \(error)")
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

// --- Helper Views ---

struct SectionHeader<Destination: View>: View {
    let title: String
    let destinationView: Destination
    var onTapSeeAll: (() -> Void)? = nil
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        let isIPad = horizontalSizeClass == .regular
        
        HStack {
            Text(title)
                .font(.noto(isIPad ? 24 : 18, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            if let action = onTapSeeAll {
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(isIPad ? 18 : 14, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 18 : 14))
                            .foregroundColor(Color.mainColor)
                    }
                }
            } else {
                NavigationLink(destination: destinationView.navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(isIPad ? 18 : 14, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 18 : 14))
                            .foregroundColor(Color.mainColor)
                    }
                }
            }
        }
    }
}

struct FrequentWasteSection: View {
    @Binding var hideTabBar: Bool
    let items: [RecyclableItem]
    
    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(title: "ขยะที่แยกบ่อย", destinationView: FrequentWasteView())
            
            HStack(spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(destination: WasteTypeView(hideTabBar: $hideTabBar, category: item.title)) {
                        RecyclableItemCard(item: item)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct RecyclableItemCard: View {
    let item: RecyclableItem
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        let isIPad = horizontalSizeClass == .regular
        
        VStack(spacing: 0) {
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: isIPad ? 120 : 92) // ขยายรูปบน iPad
            
            VStack(spacing: 2) {
                Text(item.title)
                    .font(.noto(isIPad ? 18 : 14, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("\(item.countNumber) ครั้ง")
                    .font(.noto(isIPad ? 14 : 10, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: isIPad ? 200 : 150) // ขยายการ์ดบน iPad
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}

struct WasteSeparationGuideSection: View {
    @Binding var currentIndex: Int
    @Binding var hideTabBar: Bool
    @Binding var tabIndex: Int
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let totalPages = 3
    let virtualPages = 300  // infinite scroll
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        let isIPad = horizontalSizeClass == .regular
        
        VStack(spacing: 7) {
            SectionHeader(
                title: "วิธีการแยกขยะ",
                destinationView: KnowledgeView(hideTabBar: $hideTabBar),
                onTapSeeAll: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        tabIndex = 2
                    }
                }
            )
            
            VStack(spacing: 12) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<virtualPages, id: \.self) { index in
                        ZStack {
                            Image("info-banner\(index % totalPages + 1)")
                                .resizable()
                                .scaledToFill() // ดันให้เต็มกรอบ
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(isIPad ? 25 : 20)
                                .clipped()
                        }
                        .padding(.horizontal, 2)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // ยิ่งตัวเลขด้านหน้าเยอะ รูปจะยิ่งดูแบน (เช่น 21/9), ถ้าเลขด้านหน้าน้อย รูปจะดูสูง (เช่น 4/3)
                .aspectRatio(isIPad ? 2.75/1 : 5.5/2, contentMode: .fit)

                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex % totalPages ? Color.mainColor : Color.thirdColor)
                            .frame(width: index == currentIndex % totalPages ? 10 : 9,
                                   height: index == currentIndex % totalPages ? 10 : 9)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    }
                }
            }
        }
        .onAppear {
            currentIndex = 0
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
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
    MainAppView(hideTabBar: .constant(false), tabIndex: .constant(0))
}
