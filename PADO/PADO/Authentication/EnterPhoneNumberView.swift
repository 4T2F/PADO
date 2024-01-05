//
//  EnterPhoneNumberView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct EnterPhoneNumberView: View {
    
    @State var showCountryList = false
    @State var buttonActive = false
    
    @Binding var phoneNumberButtonClicked: Bool
    
    @FocusState private var focusedField: Bool
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var tfFormat = PhoneumberTFFormat()
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("PADO.")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("휴대폰 번호를 입력해주세요")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 16))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .frame(width: 75, height: 45)
                            .foregroundStyle(.gray)
                            .overlay {
                                Text("\(viewModel.country.flag(country: viewModel.country.isoCode))")
                                +
                                Text("+\(viewModel.country.phoneCode)")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                            }
                            .onTapGesture {
                                self.showCountryList.toggle()
                            }
                        
                        TextField("NUMBER", text: $viewModel.phoneNumber)
                            .frame(width: 280)
                            .keyboardType(.numberPad)
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .tint(.cursor)
                            .focused($focusedField)
//                            .onChange(of: viewModel.phoneNumber) { newValue, _ in
//                                viewModel.phoneNumber = tfFormat.formatPhoneNumber(newValue)
//                            }
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    Button("뒤로가기") {
                        // 버튼 클릭 시 상위 뷰로 돌아감
                       
                    }
                    .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    
                    Text("계속 진행시 개인정보처리방침과 이용약관에 동의처리 됩니다")
                        .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        Task {
                            await viewModel.checkPhoneNumberExists(phoneNumber: "+\(viewModel.country.phoneCode)\(viewModel.phoneNumber)")
                        }
                    } label: {
                        WhiteButtonView(buttonActive: $buttonActive, text: "인증 문자 보내기")
                            .onChange(of: viewModel.phoneNumber) { _, newValue in
                                if newValue.count > 9 {
                                    buttonActive = true
                                } else {
                                    buttonActive = false
                                }
                            }
                    }
                    .disabled(viewModel.phoneNumber.isEmpty ? true : false)
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = true
            }
        }
        .onTapGesture {
            self.endTextEditiong()
        }
        .sheet(isPresented: $showCountryList, content: {
            SelectCountryView(countryChosen: $viewModel.country)
        })
        .overlay {
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .background {
            NavigationLink(tag: "VERIFICATION", selection: $viewModel.navigationTag) {
                EnterCodeView()
                    .environmentObject(viewModel)
            } label: {
                EmptyView()
            }
            .onChange(of: viewModel.phoneNumber) { newValue, _ in
                buttonActive = !newValue.isEmpty
            }
        }
        .environment(\.colorScheme, .dark)
    }
}



//#Preview {
//    EnterPhoneNumberView()
//}
