//
//  ProfileReprotModalView.swift
//  PADO
//
//  Created by 강치우 on 2/10/24.
//

import SwiftUI

struct ReprotProfileModalView: View {
    @State private var isShowingReportView: Bool = false
    
    var body: some View {
        ZStack {
            Color.modal.ignoresSafeArea()
            
            VStack {
                Button {
                    //
                } label: {
                    HStack {
                        Text("숨기기")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "eye.slash")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(.modalCell)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 8)
                
                VStack {
                    Button {
                        //
                    } label: {
                        HStack {
                            Text("차단")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            
                            Spacer()
                            
                            Image(systemName: "person.slash")
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 6)
                    
                    Button {
                        isShowingReportView.toggle()
                    } label: {
                        HStack {
                            Text("신고")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            
                            Spacer()
                            
                            Image(systemName: "exclamationmark.bubble")
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $isShowingReportView) {
                            ReportUserView(isShowingReportView: $isShowingReportView)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
                .padding()
                .background(.modalCell)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 20)
        }
    }
}
