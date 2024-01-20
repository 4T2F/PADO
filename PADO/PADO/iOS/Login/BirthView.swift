//
//  BirthView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct BirthView: View {
    
    @State private var birth: String = ""
    @State var buttonActive: Bool = false
    @Binding var currentStep: SignUpStep

    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {     
            VStack(alignment: .leading) {
                // id값 불러오는 로직 추가 해야함
                Text("\(viewModel.nameID)님 환영합니다\n생일을 입력해주세요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomTF(hint: "YYYY / MM / DD", value: $birth)
                        .keyboardType(.numberPad)
                        .tint(.white)
                    
                    VStack(alignment: .leading) {
                        Text("공개여부를 선택할 수 있어요")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    // 다음 뷰로 넘어가는 네비게이션 링크 추가 해야함
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "가입하기")
                    // true 일 때 버튼 변하게 하는 onChange 로직 추가해야함
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
        }
    }
}

//#Preview {
//    BirthView(viewModel: MainView().viewModel)
//}
