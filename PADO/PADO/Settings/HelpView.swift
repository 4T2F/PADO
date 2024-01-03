//
//  HelpView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("도움 받기")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 16) {
                        NavigationLink {
                            ContactUsView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            ChevronButtonView(icon: "envelope", text: "문의하기")
                        }

                        ChevronButtonView(icon: "questionmark.circle", text: "질의응답")
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                }
            }
        }
    }
}

#Preview {
    HelpView()
}
