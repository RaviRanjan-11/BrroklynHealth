//
//  LanguageDropDownView.swift
//  Brooklyn Health
//
//  Created by Ravi Ranjan on 20/04/25.
//

import SwiftUI

struct LanguageDropdown: View {
    @EnvironmentObject var viewModel: LanguageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                withAnimation {
                    viewModel.isLanguageTapped.toggle()
                }
            } label: {
                HStack {
                    Text(viewModel.selectedLanguage.displayName)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(viewModel.isLanguageTapped ? 90 : 0))
                        .animation(.easeInOut, value: viewModel.isLanguageTapped)
                        .font(.system(size: 14))
                        .foregroundColor(Colors.primaryBackground)
                }
            }
            
            if viewModel.isLanguageTapped {
                VStack(alignment: .leading) {
                    ForEach(SupportedLanguage.allCases) { language in
                        Button(action: {
                            withAnimation {
                                viewModel.selectLanguage(language)
                                viewModel.isLanguageTapped = false
                            }
                        }) {
                            Text(language.displayName)
                                .foregroundColor(.primary)
                                .padding(4)
                        }
                    }
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}
