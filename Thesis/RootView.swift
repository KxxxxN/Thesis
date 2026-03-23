//
//  RootView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldHideTabBar = false

    var body: some View {
        if isLoggedIn || authViewModel.isAuthenticated {  // ✅ เช็คทั้งคู่
            ContentView(hideTabBar: $shouldHideTabBar)
        } else {
            LoginView()
                .environmentObject(authViewModel)  // ✅ ส่งต่อให้ LoginView
        }
    }
}
