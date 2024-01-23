//
//  CustomModalView.swift
//  PADO
//
//  Created by 김명현 on 1/23/24.
//

import SwiftUI

struct CustomModalView: View {
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }

        }
        .padding()
    }
}



#Preview {
    CustomModalView()
}
