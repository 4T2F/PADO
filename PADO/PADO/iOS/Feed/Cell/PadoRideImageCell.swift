//
//  PadoRideImageCell.swift
//  PADO
//
//  Created by 강치우 on 3/17/24.
//

import Kingfisher

import SwiftUI

struct PadoRideImageCell: View {
    @Binding var isLoading: Bool
    @Binding var isHeaderVisible: Bool
    
    var padoRide: PadoRide
    
    var body: some View {
        ZStack {
            KFImage.url(URL(string: padoRide.imageUrl))
                .resizable()
                .scaledToFit()
                .blur(radius: 50)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.65)
                .containerRelativeFrame([.horizontal,.vertical])
                .overlay {
                    ImageLoadingCell(isLoading: $isLoading,
                                     isHeaderVisible: $isHeaderVisible,
                                     imageUrl: padoRide.imageUrl)
                    .cornerRadius(15)
                }
        }
    }
}
