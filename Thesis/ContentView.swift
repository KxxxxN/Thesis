//
//  ContentView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/10/2568 BE.
//


//
//  ContentView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/10/2568 BE.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    
    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack{
                
                if self.index == 0 {
                    
                    MainAppView()
                    
                }
                else if self.index == 1 {
                    
                    Color.red
                    
                }
                else if self.index == 2 {
                    
                    Color.yellow
                    
                }
                else {
                    
                    Color.green
                    
                }
                
            }
            
            MainTabView(index: self.$index)
            
        }
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

#Preview {
    ContentView()
}
