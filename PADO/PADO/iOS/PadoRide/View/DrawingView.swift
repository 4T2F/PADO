//
//  DrawingView.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import SwiftUI

struct DrawingView: View {
    @ObservedObject var padorideVM: PadoRideViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                
                let size = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    if padorideVM.rect == .zero {
                        padorideVM.rect = size
                    }
                }
                
                return AnyView(
                    ZStack {
                        CanvasView(padorideVM: padorideVM,
                                   canvas: $padorideVM.canvas,
                                   toolPicker: $padorideVM.toolPicker,
                                   rect: size.size)
                        .onTapGesture {
                            Task {
                                padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                                padorideVM.canvas.becomeFirstResponder()
                            }
                        }
                        
                        ForEach(padorideVM.textBoxes) { box in
                            
                            Text(padorideVM.textBoxes[padorideVM.currentIndex].id == box.id && padorideVM.addNewBox ? "" : box.text)
                                .font(.system(size: 30))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .gesture(DragGesture().onChanged({ (value) in
                                    
                                    let current = value.translation
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                    
                                    padorideVM.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                    
                                }).onEnded({ (value) in
                                    padorideVM.textBoxes[getIndex(textBox: box)].lastOffset = padorideVM.textBoxes[getIndex(textBox: box)].offset
                                    
                                }))
                                .onLongPressGesture {
                                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                                    padorideVM.canvas.resignFirstResponder()
                                    padorideVM.currentIndex = getIndex(textBox: box)
                                    withAnimation{
                                        padorideVM.addNewBox = true
                                    }
                                }
                        }
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    padorideVM.textBoxes.append(TextBox())
                    
                    padorideVM.currentIndex = padorideVM.textBoxes.count - 1
                    
                    withAnimation{
                        padorideVM.addNewBox.toggle()
                    }
                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                    padorideVM.canvas.resignFirstResponder()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    padorideVM.showingModal = true
                    padorideVM.saveImage()
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $padorideVM.showingModal) {
            SendPadoView(padorideVM: padorideVM)
                .presentationDetents([.fraction(0.2)])
        }
    }
    
    func getIndex(textBox: TextBox) -> Int{
        
        let index = padorideVM.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
}
