//
//  LeftMenuTopView.swift
//  BeReal
//
//  Created by 강치우 on 1/1/24.
//

import SwiftUI

struct LeftMenuTopView: View {
    
    @State var text = ""
    @State var isEditing = false
    
    @Binding var mainMenu: String
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            self.mainMenu = "feed"
                        }
                    } label: {
                        Image(systemName: "arrow.forward")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal)
                
                Text("PADO.")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 22))
            }
            
            SearchBar(text: $text, isEditing: $isEditing)
            
            Spacer()
        }
    }
}

#Preview {
    LeftMenuTopView(mainMenu: .constant("left"))
}
