//
//  EnterAgeView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI
import Combine

enum Field: Hashable {
    case month
    case day
    case year
}

struct EnterAgeView: View {
    
    // 포커스 상태를 저장하는 @FocusState 프로퍼티
    @FocusState private var focusedField: Field?
    
    @Binding var year: Year
    @Binding var name: String
    
    @State var buttonActive = false
    
    @Binding var ageButtonClicked: Bool
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
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
                    Text("안녕하세요 \(name)님, 생일을 입력해주세요")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 16))
                    
                    HStack(spacing: 4) {
                        TextField("YYYY", text: $year.year)
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                            .fontWeight(.heavy)
                            .frame(width: 120)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .tint(.cursor)
                            .focused($focusedField, equals: .year)
                            .onChange(of: year.year, { oldValue, newValue in
                                if newValue.count == 4 {
                                    focusedField = .month
                                }
                            })
                            .onReceive(Just(year.year), perform: { newValue in
                                let filtered = newValue.filter {
                                    Set("01234567890").contains($0)
                                }
                                if newValue != newValue {
                                    self.year.year = filtered
                                }
                            })
                            .onReceive(Just(year.year), perform: { _ in
                                if year.year.count > 4 {
                                    year.year = String(year.year.prefix(4))
                                }
                            })
                        
                        TextField("MM", text: $year.month)
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                            .fontWeight(.heavy)
                            .frame(width: 72)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .tint(.cursor)
                            .focused($focusedField, equals: .month)
                            .onSubmit {
                                if year.month.count == 1 {
                                    year.month = "0" + year.month
                                }
                            }
                            .onChange(of: year.month, { oldValue, newValue in
                                if newValue.count == 2 {
                                    focusedField = .day
                                } else if year.year.count == 4 && newValue.count == 0 {
                                    focusedField = .year
                                }
                            })
                            .onReceive(Just(year.month), perform: { newValue in
                                let filtered = newValue.filter {
                                    Set("01234567890").contains($0)
                                }
                                if newValue != newValue {
                                    self.year.month = filtered
                                }
                            })
                            .onReceive(Just(year.month), perform: { _ in
                                if year.month.count > 2 {
                                    year.month = String(year.month.prefix(2))
                                }
                            })
                        
                        TextField("DD", text: $year.day)
                            .foregroundStyle(.white)
                            .font(.system(size: 40))
                            .frame(width: 70)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .tint(.cursor)
                            .focused($focusedField, equals: .day)
                            .onSubmit {
                                if year.day.count == 1 {
                                    year.day = "0" + year.day
                                }
                            }
                            .onChange(of: year.day, { oldValue, newValue in
                                if year.month.count == 2 && newValue.count == 0 {
                                    focusedField = .month
                                }
                            })
                            .onReceive(Just(year.day), perform: { newValue in
                                let filtered = newValue.filter {
                                    Set("01234567890").contains($0)
                                }
                                if newValue != newValue {
                                    self.year.day = filtered
                                }
                            })
                            .onReceive(Just(year.day), perform: { _ in
                                if year.day.count > 2 {
                                    year.day = String(year.day.prefix(2))
                                }
                            })
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    Text("파도에 오신걸 환영해요")
                        .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                    
                    Button {
                        if buttonActive {
                            ageButtonClicked = true
                        } else {
                            buttonActive = false
                        }
                    } label: {
                        WhiteButtonView(buttonActive: $buttonActive, text: "계속하기")
                            .onChange(of: year.month) { _, _ in updateButtonActive() }
                            .onChange(of: year.day) { _, _ in updateButtonActive() }
                            .onChange(of: year.year) { _, _ in updateButtonActive() }
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear() {
            year.month = ""
            year.day = ""
            year.year = ""
        }
        .onTapGesture {
            self.endTextEditiong()
        }
    }
    
    // 날짜가 완전히 입력되었는지 확인하는 함수
    private func isDateFullyEntered() -> Bool {
        return year.month.count == 2 && year.day.count == 2 && year.year.count == 4
    }
    
    // buttonActive 상태를 업데이트하는 함수
    private func updateButtonActive() {
        buttonActive = isDateFullyEntered()
    }
}

//#Preview {
//    EnterAgeView()
//}
