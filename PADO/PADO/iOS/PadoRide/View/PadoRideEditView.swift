//
//  PadoRideEditView.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import PencilKit
import SwiftUI

struct PadoRideEditView: View {
    @ObservedObject var padorideVM: PadoRideViewModel
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            NavigationView {
                VStack {
                    DrawingView(padorideVM: padorideVM)
                        .navigationTitle("편집")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    padorideVM.cancelImageEditing()
                                    dismiss()
                                } label: {
                                    Image("dismissArrow")
                                }
                            }
                        }
                }
            }
            
            if padorideVM.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("여기에 입력하세요", text: $padorideVM.textBoxes[padorideVM.currentIndex].text)
                    .font(.system(size: 35, weight: padorideVM.textBoxes[padorideVM.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(padorideVM.textBoxes[padorideVM.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button {
                        padorideVM.cancelTextView()
                    } label: {
                        Text("삭제")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        padorideVM.textBoxes[padorideVM.currentIndex].isAdded = true
                        padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                        padorideVM.canvas.becomeFirstResponder()
                        withAnimation{
                            padorideVM.addNewBox = false
                        }
                    } label: {
                        Text("추가")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .overlay(
                    HStack(spacing: 15){
                        ColorPicker("", selection: $padorideVM.textBoxes[padorideVM.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            padorideVM.textBoxes[padorideVM.currentIndex].isBold.toggle()
                        } label: {
                            Text(padorideVM.textBoxes[padorideVM.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

