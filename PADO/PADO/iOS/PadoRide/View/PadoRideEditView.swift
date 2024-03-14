//
//  PadoRideEditView.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import SwiftUI

struct PadoRideEditView: View {
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var padorideVM: PadoRideViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    DrawingView(padorideVM: padorideVM)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
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
                
                TextField("여기에 입력하세요", text: $padorideVM.textBoxes[padorideVM.currentTextIndex].text)
                    .font(.system(size: 35, weight: padorideVM.textBoxes[padorideVM.currentTextIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(padorideVM.textBoxes[padorideVM.currentTextIndex].textColor)
                    .padding()
                
                HStack {
                    Button {
                        Task {
                            await padorideVM.cancelTextView()
                        }
                    } label: {
                        Text("취소")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        padorideVM.textBoxes[padorideVM.currentTextIndex].isAdded = true
                        Task {
                            padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                            padorideVM.canvas.becomeFirstResponder()
                        }
                        withAnimation {
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
                        ColorPicker("", selection: $padorideVM.textBoxes[padorideVM.currentTextIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            padorideVM.textBoxes[padorideVM.currentTextIndex].isBold.toggle()
                        } label: {
                            Text(padorideVM.textBoxes[padorideVM.currentTextIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
            
            if padorideVM.modifyBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("여기에 입력하세요", text: $padorideVM.textBoxes[padorideVM.currentTextIndex].text)
                    .font(.system(size: 35, weight: padorideVM.textBoxes[padorideVM.currentTextIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(padorideVM.textBoxes[padorideVM.currentTextIndex].textColor)
                    .padding()
                
                HStack {
                    Button {
                        padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                        padorideVM.canvas.becomeFirstResponder()
                        withAnimation {
                            padorideVM.modifyBox = false
                        }
                    } label: {
                        Text("취소")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await padorideVM.cancelTextView()
                        }
                    } label: {
                        Text("삭제")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .overlay(
                    HStack(spacing: 15){
                        ColorPicker("", selection: $padorideVM.textBoxes[padorideVM.currentTextIndex].textColor)
                            .labelsHidden()
                        
                        Button {
                            padorideVM.textBoxes[padorideVM.currentTextIndex].isBold.toggle()
                        } label: {
                            Text(padorideVM.textBoxes[padorideVM.currentTextIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onDisappear {
            padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
            padorideVM.cancelImageEditing()
            dismiss()
        }
        .navigationBarBackButtonHidden()
    }
}

