//
//  UserProfile.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


//
//  UserProfileViewModel.swift
//  Thesis
//

import SwiftUI
import Supabase

struct UserProfile: Decodable {
    let firstName: String
    let lastName: String
    let points: Int

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName  = "last_name"
        case points
    }
}

@MainActor
class UserProfileViewModel: ObservableObject{
    @Published var fullName: String = ""
    @Published var totalPoints: Int = 0
    @Published var profileImage: UIImage? = nil
    @Published var isLoading: Bool = false
    
    func fetchProfile(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        await fetchName()
        await fetchTotalPoints(userId: userId)
    }
    
    // ✅ ดึงชื่อ-นามสกุลจาก table users
    private func fetchName() async {
        do {
            let user = try await supabase.auth.session.user
            let meta = user.userMetadata

            let firstName = meta["first_name"]?.stringValue ?? ""
            let lastName  = meta["last_name"]?.stringValue ?? ""
            fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)

            // ✅ โหลดรูป avatar
            if let avatarURLString = meta["avatar_url"]?.stringValue,
               let url = URL(string: avatarURLString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.profileImage = image
                }
            }
        } catch {
            fullName = "ไม่พบข้อมูล"
            print("❌ fetchName error: \(error)")
        }
    }
    
    // ✅ SUM points จาก table scan_history
    private func fetchTotalPoints(userId: UUID) async {
        do {
            struct PointsRow: Decodable {
                let points: Int
            }
            
            let rows: [PointsRow] = try await supabase
                .from("scan_history")
                .select("points")
                .eq("user_id", value: userId.uuidString)  // ✅ ส่งเป็น String
                .execute()
                .value
            
            totalPoints = rows.reduce(0) { $0 + $1.points }
        } catch {
            totalPoints = 0
            print("❌ fetchTotalPoints error: \(error)")
        }
    }
}

