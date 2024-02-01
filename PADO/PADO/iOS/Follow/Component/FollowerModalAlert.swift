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
    
    @State var followerUsername: String = ""
    @State var followerProfileUrl: String = ""
    @State var buttonText1: String = ""
    @State var buttonText2: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    KFImage.url(URL(string: followerProfileUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                    
                    Text(followerUsername)
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                    
                    Divider()
                    
                    Button {
                        //
                    } label: {
                        Text(buttonText1)
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                    }
                    
                    Divider()
                    
                    Button {
                        //
                    } label: {
                        Text(buttonText2)
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                    }
                }
                .foregroundStyle(Color.white)
                .padding(30)
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
