//
//  PadoRideCell.swift
//  PADO
//
//  Created by 황성진 on 2/10/24.
//

import SwiftUI

struct PadoRideCell: View {
    let padoRide: PadoRide
    
    var body: some View {
        VStack {
            // PadoRide 모델에 맞게 내용 표시
            Text("PadoRide Title: \(padoRide.storageFileName)")
            Text("Description: \(padoRide.time)")
            // 기타 필요한 정보 표시
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
