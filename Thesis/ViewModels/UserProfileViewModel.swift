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
class UserProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var points: Int = 0
    @Published var isLoading: Bool = false

    func fetchProfile(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let profile: UserProfile = try await supabase
                .from("users")
                .select("first_name, last_name, points")
                .eq("id", value: userId)
                .single()
                .execute()
                .value

            fullName = "\(profile.firstName) \(profile.lastName)"
            points   = profile.points
        } catch {
            fullName = "ไม่พบข้อมูล"
            points   = 0
            print("❌ fetchProfile error: \(error)")
        }
    }
}