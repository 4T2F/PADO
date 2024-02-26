//
//  FollowerModalAlert.swift
//  PADO
//
//  Created by 강치우 on 2/1/24.
//

import Kingfisher
import SwiftUI

struct FollowerModalAlert: View {
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    @State var followerUsername: String
    @State var followerProfileUrl: String
    @State var buttonText1: String
    @State var buttonText2: String?
    
    var onButton1: (() async -> Void)?
    var onButton2: (() async -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    UrlProfileImageView(imageUrl: followerProfileUrl,
                                        size: .large,
                                        defaultImageName: "defaultProfile")
                    
                    Text(followerUsername)
                        .font(.system(.footnote))
                        .fontWeight(.medium)
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.vertical, 4)
                    
                    Button {
                        if let onButton1 = onButton1 {
                            Task {
                                await onButton1()
                            }
                        }
                        
                    } label: {
                        Text(buttonText1)
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundStyle(.red)
                    }
                }
                .foregroundStyle(Color.white)
                .padding(15)
            }
            .frame(width: width * 0.9)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 22))
            
            VStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .fontWeight(.regular)
                        .frame(width: width * 0.9, height: 40)
                }
            }
            .frame(width: width * 0.9)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 12))
        }
        .background(ClearBackground())
    }
}
