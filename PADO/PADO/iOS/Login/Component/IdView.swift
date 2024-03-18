//
//  IdView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct IdView: View {
    @ObservedObject var loginVM: LoginViewModel
    
    @State var buttonActive: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("파도에서 사용할 아이디를 입력해주세요")
                    .font(.system(.title2))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(value: $loginVM.nameID,
                             hint: "ID를 입력해주세요")
                        .keyboardType(.asciiCapable)
                        .tint(.white)
                        .onChange(of: loginVM.nameID) { _, newValue in
                            buttonActive = newValue.count > 3
                            if loginVM.isDuplicateID {
                                loginVM.isDuplicateID = false
                            }
                        }
                    if loginVM.isDuplicateID {
                        Text("사용할 수 없는 ID입니다.")
                            .font(.system(.subheadline))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                    } else {
                        VStack(alignment: .leading) {
                            Text("영어, 숫자(4글자 이상)만 사용 가능해요")
                            
                            Text("한 번 설정한 ID는 수정 불가능해요")
                        }
                        .font(.system(.subheadline))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    if buttonActive {
                        loginVM.selectID()
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
