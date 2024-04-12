//
//  PostSelectModalView.swift
//  PADO
//
//  Created by 최동호 on 2/18/24.
//

import SwiftUI

struct PostSelectModalView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    let title: String
    
    var onTouchButton: () async -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    Text(title)
                        .font(.system(.body))
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color.white)
                .font(.system(.subheadline))
                .fontWeight(.medium)
                .padding()
                
                Divider()
                
                Button {
                    Task {
                        await onTouchButton()
                        dismiss()
                    }
                } label: {
                    Text("삭제")
                        .font(.system(.body))
                        .foregroundStyle(Color.red)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
                .padding(.bottom, 5)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 22))
            
            VStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(.body))
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
            }
            .frame(width: width * 0.9, height: 50)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 12))
        }
        .background(ClearBackground())
        
    }
}
