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
        
        // Home Screen...
        ZStack {
            NavigationView {
                
                VStack {
                    DrawingView(padorideVM: padorideVM)
                    // setting cancel button if image selected...
                        .navigationTitle("편집하기")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    padorideVM.selectedUIImage = nil
                                    padorideVM.selectedImage = ""
                                    dismiss()
                                } label: {
                                    Image("dismissArrow")
                                }
                            }
                        })
                    Spacer()
                }
            }
            
            if padorideVM.addNewBox {
                
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                // TextField...
                TextField("Type Here", text: $padorideVM.textBoxes[padorideVM.currentIndex].text)
                    .font(.system(size: 35, weight: padorideVM.textBoxes[padorideVM.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(padorideVM.textBoxes[padorideVM.currentIndex].textColor)
                    .padding()
                
                // add and cancel button...
                HStack {
                    
                    Button(action: {
                        // toggling the isAdded...
                        padorideVM.textBoxes[padorideVM.currentIndex].isAdded = true
                        // closing the view...
                        padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                        padorideVM.canvas.becomeFirstResponder()
                        withAnimation{
                            padorideVM.addNewBox = false
                        }
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: padorideVM.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                .overlay(
                    HStack(spacing: 15){
                        
                        // Color Picker...
                        ColorPicker("", selection: $padorideVM.textBoxes[padorideVM.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button(action: {
                            padorideVM.textBoxes[padorideVM.currentIndex].isBold.toggle()
                        }, label: {
                            Text(padorideVM.textBoxes[padorideVM.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

