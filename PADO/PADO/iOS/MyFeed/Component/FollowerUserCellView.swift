//
//  FollowerUserCellView.swift
//  PADO
//
//  Created by 황성진 on 1/16/24.
//

import SwiftUI

struct FollowerUserCellView: View {
    // MARK: - PROPERTY
    enum SufferSet: String {
        case removesuffer = "서퍼 해제"
        case setsuffer = "서퍼 등록"
    }
    
    
    @State private var buttonActive: Bool = false
    @State var transitions: Bool = false
    
    let sufferset: SufferSet
    
    // MARK: - BODY
    var body: some View {
        HStack {
            CircularImageView(size: .small)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("user ID")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("user nickname")
                    .font(.system(size: 14, weight: .semibold))
            } //: VSTACK
            
            Spacer()
            
            if transitions {
                Button {
                    transitions = false
                } label: {
                    Text(sufferset.rawValue)
                        .padding()
                        .foregroundStyle(.black)
                        .background(.white)
                }
                .offset(x: 8)
                
                Button {
                    transitions = false
                } label: {
                    Text("삭제")
                        .padding()
                        .foregroundColor(.white)
                        .background(.red)
                }
            }
            
        } //: HSTACK
        .gesture(
            DragGesture()
                .onChanged({ value in
                    transitions = true
                })
        )
        .onTapGesture {
            transitions = false
        }
    }
}

#Preview {
    FollowerUserCellView(sufferset: .removesuffer)
}
