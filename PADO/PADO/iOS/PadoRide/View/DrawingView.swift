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
        
        ZStack{
            GeometryReader { proxy -> AnyView in
                
                let size = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    if padorideVM.rect == .zero {
                        padorideVM.rect = size
                    }
                }
                
                return AnyView(
                    ZStack {
                            // UIkit Pencil Kit Drawing View...
                            CanvasView(padorideVM: padorideVM, canvas: $padorideVM.canvas, toolPicker: $padorideVM.toolPicker,rect: size.size)
                            
                        // CUstom Texts....
                        
                        // displaying text boxes..
                        ForEach(padorideVM.textBoxes) { box in
                            
                            Text(padorideVM.textBoxes[padorideVM.currentIndex].id == box.id && padorideVM.addNewBox ? "" : box.text)
                                // you can also include text size in model..
                                // and can use those text sizes in these text boxes...
                                .font(.system(size: 30))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                            // drag gesutre...
                                .gesture(DragGesture().onChanged({ (value) in
                                    
                                    let current = value.translation
                                    // Adding with last Offset...
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                    
                                    padorideVM.textBoxes[getIndex(textBox: box)].offset = newTranslation
                                    
                                }).onEnded({ (value) in
                                    
                                    // saving the last offset for exact drag postion...
                                    padorideVM.textBoxes[getIndex(textBox: box)].lastOffset = padorideVM.textBoxes[getIndex(textBox: box)].offset
                                    
                                }))
                            // editing the typed one...
                                .onLongPressGesture {
                                    // closing the toolbar...
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
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                
//                Button(action: model.saveImage, label: {
//                    Text("Save")
//                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    // creating One New Box...
                    padorideVM.textBoxes.append(TextBox())
                    
                    // upating index..
                    padorideVM.currentIndex = padorideVM.textBoxes.count - 1
                    
                    withAnimation{
                        padorideVM.addNewBox.toggle()
                    }
                    // closing the tool bar...
                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                    padorideVM.canvas.resignFirstResponder()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                })
            }
        })
    }
    
    func getIndex(textBox: TextBox)->Int{
        
        let index = padorideVM.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
}
