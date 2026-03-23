//
//  WasteTypeViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


//
//  WasteTypeViewModel.swift
//  Thesis
//

import SwiftUI
import Supabase

@MainActor
class WasteTypeViewModel: ObservableObject {
    @Published var items: [WasteTypeItem] = []
    @Published var isLoading: Bool = false

    func fetchItems(category: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.session

            struct ScanRow: Decodable {
                let category: String
                let imageUrl: String?
                let scannedAt: String
                enum CodingKeys: String, CodingKey {
                    case category
                    case imageUrl = "image_url"
                    case scannedAt = "scanned_at"
                }
            }

            let rows: [ScanRow] = try await supabase
                .from("scan_history")
                .select("category, image_url, scanned_at")
                .eq("user_id", value: session.user.id.uuidString)
                .eq("category", value: category)
                .order("scanned_at", ascending: false)
                .execute()
                .value

            let parser = DateFormatter()
            parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            parser.locale = Locale(identifier: "en_US_POSIX")

            let display = DateFormatter()
            display.dateFormat = "d/M/yyyy"
            display.locale = Locale(identifier: "en_US_POSIX")
            display.calendar = Calendar(identifier: .gregorian)

            items = rows.map { row in
                let cleanedDate = String(row.scannedAt.prefix(19))
                let dateStr = parser.date(from: cleanedDate).map { display.string(from: $0) } ?? row.scannedAt
                return WasteTypeItem(
                    title: row.category,
                    date: dateStr,
                    imageUrl: row.imageUrl
                )
            }
        } catch {
            print("❌ fetchItems error: \(error)")
        }
    }
}
