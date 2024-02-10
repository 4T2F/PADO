//
//  BirthView.swift
//  PADO
//
//  Created by 강치우 on 1/15/24.
//

import SwiftUI

struct BirthView: View {
    @State var showBirthAlert: Bool = false
    @State var buttonActive: Bool = false
    @Binding var currentStep: SignUpStep

    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {     
            VStack(alignment: .leading) {
                // id값 불러오는 로직 추가 해야함
                Text("\(viewModel.nameID)님 환영합니다\n생일을 입력해주세요")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 8, content: {
                        VStack(alignment: .leading, spacing: 8, content: {
                            TextField("생년월일", text: $viewModel.year)
                                .disabled(true)
                                .tint(.white)
                                .onChange(of: viewModel.year) { _, newValue in
                                    buttonActive = newValue.count > 0
                                }
                            
                            Divider()
                        })
                    })
                    
                    VStack(alignment: .leading) {
                        Text("공개여부를 선택할 수 있어요")
                    }
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    DatePicker("", selection: $viewModel.birthDate,
                               displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .environment(\.locale, Locale.init(identifier: "ko"))
                    .labelsHidden()
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                Button {
                    if buttonActive {
                        if isFourteenOrOlder(birthDate: viewModel.birthDate) {
                            Task{
                                await viewModel.signUpUser()
                            }
                        } else {
                            showBirthAlert = true
                        }
                    }
                } label: {
                    WhiteButtonView(buttonActive: $buttonActive, text: "가입하기")
                    // true 일 때 버튼 변하게 하는 onChange 로직 추가해야함
                }
                .padding(.bottom)
            }
            .padding(.top, 150)
        }
        .sheet(isPresented: $showBirthAlert) {
            BirthAlertModal()
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        }
    }
    
    func isFourteenOrOlder(birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let fourteenYearsAgo = calendar.date(byAdding: .year, value: -14, to: Date())!
        return birthDate <= fourteenYearsAgo
    }
}
