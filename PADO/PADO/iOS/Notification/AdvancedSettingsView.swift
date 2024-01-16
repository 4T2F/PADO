//
//  AdvancedSettingsView.swift
//  PADO
//
//  Created by 강치우 on 1/16/24.
//

import SwiftUI

struct AdvancedSettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.mainBackground.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        ScrollView {
                            VStack(spacing: 25) {
                                Divider()
                                
                                AdvancedSettingsCell(mainTitle: "좋아요 및 조회수", title: "이 게시물의 좋아요 수 숨기기", subtitle: "이 게시물의 총 좋아요 수는 회원님만 볼 수 있어요",toggleOnOff: false)
                                
                                Divider()
                                
                                AdvancedSettingsCell(mainTitle: "댓글", title: "댓글 기능 해제", subtitle: "설정 시 이 게시물에서는 댓글 기능을 이용할 수 없어요",toggleOnOff: false)
                                
                                Divider()
                                
                                AdvancedSettingsCell(mainTitle: "FaceMoji", title: "FaceMoji 기능 해제", subtitle: "해제할 시 이 게시물에서는 FaceMoji 기능을 이용할 수 없어요",toggleOnOff: false)
                                
                                Divider()
                            }
                            .padding(.top, 50)
                        }
                        VStack {
                            ZStack {
                                Text("고급 설정")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "arrow.backward")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 20))
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AdvancedSettingsView()
}
