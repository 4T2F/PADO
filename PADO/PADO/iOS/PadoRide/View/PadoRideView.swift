//
//  PadoRideView.swift
//  PADO
//
//  Created by 황성진 on 2/7/24.
//

import SwiftUI

struct PadoRideView: View {
    // MARK: - PROPERTY
    @ObservedObject var followVM: FollowViewModel
    @ObservedObject var padorideVM: PadoRideViewModel
    
    @State var isShowingEditView: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                
                Text("파도타기")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 40)
                
                Spacer()
                
                if padorideVM.selectedImage.isEmpty {
                    Button {
                    } label: {
                        Text("다음")
                            .foregroundStyle(.gray)
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.trailing, 10)
                    }
                } else {
                    Button {
                        padorideVM.downloadSelectedImage()
                        isShowingEditView.toggle()
                    } label: {
                        Text("다음")
                            .foregroundStyle(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.trailing, 10)
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingEditView) {
                PadoRideEditView(padorideVM: padorideVM)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(followVM.surfingIDs, id: \.self) { surfingID in
                        SufferInfoCell(surfingID: surfingID)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                SufferPostCell(padorideVM: padorideVM,
                                               suffingPost: padorideVM.postsData[surfingID],
                                               surfingID: surfingID)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await padorideVM.preloadPostsData(for: followVM.surfingIDs)
            }
        }
    }
}
