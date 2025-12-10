//
//  TranslateView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct TranslateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedLanguageCode: String = "TH"
    
    let languages = [
        (code: "TH", name: "ภาษาไทย", image: "Thai"),
        (code: "EN", name: "English", image: "English")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            ZStack {
                Text("เปลี่ยนภาษา")
                    .font(.noto(25, weight: .bold))
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding(.leading, 25)

                    Spacer()
                }
            }
                                    
            // Language Selection List
            VStack(spacing: 0) {
                ForEach(languages, id: \.code) { lang in
                    LanguageSelectionRow(
                        code: lang.code,
                        name: lang.name,
                        imageName: lang.image,
                        selectedCode: selectedLanguageCode //
                    ) { newCode in
                        selectedLanguageCode = newCode
                    }
                }
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TranslateView()
}
