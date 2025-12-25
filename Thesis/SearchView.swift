//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @State private var showAiScanView = false
    @State private var showSearchView = false
    
    @State private var selectedTabnavigationItem = 1
    
    var body: some View {
        Text("Hello, SearchView!")
        
        
    }
}


