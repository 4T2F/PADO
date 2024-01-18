//
//  SettingOthers.swift
//  PADO
//
//  Created by 황민채 on 1/15/24.
//
import SwiftUI

struct SettingOthersView: View {
    @State private var showingCashModal: Bool = false
    @State private var showingDeleteModal: Bool = false
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color("mainBackgroundColor").ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("다른설정들")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
                VStack {
                    Button {
                        showingCashModal.toggle()
                    } label: {
                        VStack {
                            SettingNormalCell(icon: "trash", text: "캐시 지우기")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Button {
                        showingDeleteModal.toggle()
                    } label: {
                        VStack {
                            SettingRedCell(icon: "multiply.square", text: "계정 삭제")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 50)
            }
        }.sheet(isPresented: $showingCashModal, content: {
            ModalAlertView(showingCircleImage: false, mainTitle: .cash, subTitle: .cash, removeMessage: .cash)
                .background(Color.clear)
                .presentationDetents([.fraction(0.4)])
        })
        
        .sheet(isPresented: $showingDeleteModal, content: {
            ModalAlertView(showingCircleImage: false, mainTitle: .account, subTitle: .account, removeMessage: .account)
                .background(Color.clear)
                .presentationDetents([.fraction(0.4)])
        })
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SettingOthersView()
}
