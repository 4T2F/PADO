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
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 36
        case .medium: return 40
        case .large: return 48
        case .xLarge: return 60
        case .xxLarge: return 80
        }
    }
}

struct CircularImageView: View {
    // MARK: - PROPERTY
    // ProfileImageSize 를 사용하기 위해 사용
    let size: ProfileImageSize
    @EnvironmentObject var viewModel: AuthenticationViewModel
    // MARK: - BODY
    var body: some View {
        if let imageUrl = viewModel.currentUser?.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

#Preview {
    CircularImageView(size: .large)
}
