//
//  EnterAgeView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI
import Combine

struct EnterAgeView: View {
    
    @State var day = ""
    @State var month = ""
    @State var year = ""
    
    @State var buttonActive = false
    @Binding var ageButtonClicked: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Text("BeReal.")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .center, spacing: 8) {
                    Text("Hi, when's your birthday?")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 16))
                    
                    HStack(spacing: 4){
                        Text("MM")
                            .foregroundStyle(month.isEmpty ? Color(red: 70/255, green: 70/255, blue: 73/255) : Color.black)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .frame(width: 72)
                            .overlay {
                                TextField("", text: $month)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 45))
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(month), perform: { newValue in
                                        let filtered = newValue.filter {
                                            Set("01234567890").contains($0)
                                        }
                                        if newValue != newValue {
                                            self.month = filtered
                                        }
                                    })
                                    .onReceive(Just(month), perform: { _ in
                                        if month.count > 2 {
                                            month = String(month.prefix(2))
                                        }
                                    })
                            }
                        
                        Text("DD")
                            .foregroundStyle(day.isEmpty ? Color(red: 70/255, green: 70/255, blue: 73/255) : Color.black)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .frame(width: 60)
                            .overlay {
                                TextField("", text: $day)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 45))
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(day), perform: { newValue in
                                        let filtered = newValue.filter {
                                            Set("01234567890").contains($0)
                                        }
                                        if newValue != newValue {
                                            self.day = filtered
                                        }
                                    })
                                    .onReceive(Just(day), perform: { _ in
                                        if day.count > 2 {
                                            day = String(day.prefix(2))
                                        }
                                    })
                            }
                        
                        Text("YYYY")
                            .foregroundStyle(year.isEmpty ? Color(red: 70/255, green: 70/255, blue: 73/255) : Color.black)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .frame(width: 120)
                            .overlay {
                                TextField("", text: $year)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 45))
                                    .fontWeight(.heavy)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(year), perform: { newValue in
                                        let filtered = newValue.filter {
                                            Set("01234567890").contains($0)
                                        }
                                        if newValue != newValue {
                                            self.year = filtered
                                        }
                                    })
                                    .onReceive(Just(year), perform: { _ in
                                        if year.count > 4 {
                                            year = String(year.prefix(4))
                                        }
                                    })
                            }
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    Text("Only to make sure you're old enough to use BeReal.")
                        .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                    
                    Button {
                        if buttonActive {
                            ageButtonClicked = true
                        }
                    } label: {
                        WhiteButtonView(buttonActive: $buttonActive, text: "Continue")
                            .onChange(of: month) { oldValue, newValue in
                                if !newValue.isEmpty {
                                    buttonActive = true
                                } else if newValue.isEmpty {
                                    buttonActive = false
                                }
                            }
                    }
                }
            }
        }
    }
}

//#Preview {
//    EnterAgeView()
//}
