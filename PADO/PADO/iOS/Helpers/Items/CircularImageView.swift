//
//  CircularImageView.swift
//  PADO
//
//  Created by 황성진 on 1/15/24.
//

import Kingfisher
import SwiftUI

// 이미지 사용을 위해 enum 형식으로 크기를 미리 정의
enum ProfileImageSize {
    case xxxSmall
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxxSmall: return 22
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 36
        case .medium: return 40
        case .large: return 48
        case .xLarge: return 70
        case .xxLarge: return 80
        case .xxxLarge: return 129
        }
    }
}

struct CircularImageView: View {
    // MARK: - PROPERTY
    // ProfileImageSize 를 사용하기 위해 사용
    let size: ProfileImageSize
    let user: User
    // MARK: - BODY
    var body: some View {
        if let imageUrl = user.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .fade(duration: 0.5)
                .placeholder{
                    Image("defaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.dimension, height: size.dimension)
                        .clipShape(Circle())
                        .foregroundStyle(Color(.systemGray4))
                }
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image("defaultProfile")
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

struct UrlProfileImageView: View {
    
    var imageUrl: String
    let size: ProfileImageSize
    var defaultImageName: String

    var body: some View {
        Group {
            if !imageUrl.isEmpty {
                KFImage(URL(string: imageUrl))
                    .resizable()
            } else {
                Image(defaultImageName)
                    .resizable()
            }
        }
        .scaledToFit()
        .frame(width: size.dimension, height: size.dimension)
        .cornerRadius(35)
    }
}
