//
//  IdView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct IdView: View {
    @State var buttonActive: Bool = false
    @State var isDuplicateID: Bool = false
    @Binding var currentStep: SignUpStep
    
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            
            
            VStack(alignment: .leading) {
                Text("파도에서 사용할 아이디를 입력해주세요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "ID를 입력해주세요", value: $viewModel.nameID)
                        .keyboardType(.asciiCapable)
                        .tint(.white)
                        .onChange(of: viewModel.nameID) { _, newValue in
                            buttonActive = newValue.count > 3
                            if isDuplicateID {
                                isDuplicateID = false
                            }
                        }
                    if isDuplicateID {
                        Text("사용할 수 없는 ID입니다.")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                    } else {
                        VStack(alignment: .leading) {
                            Text("영어, 숫자(4글자 이상)만 사용 가능해요")
                            
                            Text("한 번 설정한 ID는 수정 불가능해요")
                        }
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    if buttonActive {
                        let regex = "^[A-Za-z0-9]+$"
                        if viewModel.nameID.range(of: regex, options: .regularExpression) != nil {
                            Task {
                                let isDuplicate = await viewModel.checkForDuplicateID()
                                if !isDuplicate {
                                    viewModel.nameID = viewModel.nameID.lowercased()
                                    currentStep = .birth
                                } else {
                                    isDuplicateID = true
                                }
                            }
                        } else {
                            isDuplicateID = true
                        }
                    }
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "다음으로")
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
        }
    }
}
//
//#Preview {
//    IdView()
//}
