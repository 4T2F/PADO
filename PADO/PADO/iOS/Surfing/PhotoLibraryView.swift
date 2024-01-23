//
//  PhotoLibraryView.swift
//  PADO
//
//  Created by 김명현 on 1/22/24.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var pickerResult: [PHPickerResult] = []
    @State private var textFieldText = ""
    @State private var showModal = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("서핑하기")
                    .font(.system(size: 22).bold())
                    .padding(.leading, 60)
                Spacer()
                Button {
                    //
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 50, height: 30)
                        Text("게시")
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing)
                    
                }
                
            }//: HSTACK
            HStack {
                Image("pp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.leading)
                Text("천랑성")
                
                    .bold()
                Spacer()
                
            }
            
            TextField("친구에게 한마디 해주세요", text: $textFieldText)
                .padding()
            Spacer()
            
        }//: VSTACK
        .sheet(isPresented: $showModal) {
            CustomModalView()
                .padding(.top, 30)
                .padding(.horizontal)
                .presentationDetents([.fraction(0.05), .fraction(0.5)])
                
        }
    }
}

    
    
    #Preview {
        PhotoLibraryView()
    }
