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
    
    let termsLink = "[이용약관](https://notch-galaxy-ab8.notion.site/de9e469fca24427cbcf16ada473c9231?pvs=4)"
    let personalInfoLink = "[개인정보 정책](https://notch-galaxy-ab8.notion.site/1069395170324617b046f096118cd815)"
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
                                .multilineTextAlignment(.leading)
                                .onChange(of: viewModel.year) { _, newValue in
                                    buttonActive = newValue.count > 0
                                }
                            
                            Divider()
                            
                            Text("만 14세 미만의 가입자는 이용할 수 없습니다.")
                                .foregroundStyle(.gray)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            
                            Group {
                                Text("가입과 동시에 파도의 ")
                                    .foregroundStyle(.gray)
                                +
                                Text(.init(termsLink))
                                    .foregroundStyle(.blue)
                                +
                                Text("과 ")
                                    .foregroundStyle(.gray)
                                +
                                Text(.init(personalInfoLink))
                                    .foregroundStyle(.blue)
                                +
                                Text("에 동의하는 것으로 간주함니다.")
                                    .foregroundStyle(.gray)
                            }
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                       
                        })
                    })

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
                                needsDataFetch.toggle()
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

