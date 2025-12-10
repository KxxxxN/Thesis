//
//  RootView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @State private var shouldHideTabBar = false

    var body: some View {
        if isLoggedIn {
            ContentView(hideTabBar: $shouldHideTabBar)
        } else {
            LoginView()
        }
    }
}
