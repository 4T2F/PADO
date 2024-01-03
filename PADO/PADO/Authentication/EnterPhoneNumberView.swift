//
//  EnterPhoneNumberView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct EnterPhoneNumberView: View {
    
    @State var country = Country(isoCode: "US")
    @State var showCountryList = false
    @State var phoneNumber = ""
    @State var buttonActive = false
    
    @Binding var phoneNumberButtonClicked: Bool
    
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create your account using your phone number")
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .font(.system(size: 16))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .frame(width: 75, height: 45)
                            .foregroundStyle(.gray)
                            .overlay {
                                Text("\(country.flag(country: country.isoCode))")
                                +
                                Text("+\(country.phoneCode)")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                            }
                            .onTapGesture {
                                self.showCountryList.toggle()
                        }
                        
                        Text("Your Phone")
                            .foregroundStyle(phoneNumber.isEmpty ? Color(red: 70/255, green: 70/255, blue: 73/255) : Color.black)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .frame(width: 220)
                            .overlay {
                                TextField("", text: $phoneNumber)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 40))
                                    .fontWeight(.heavy)
                            }
                    }
                    // .padding(.leading, UIScreen.main.bounds.width * 0.05)
                    
                    Spacer()
                }
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    Text("By tapping \"Continue\", youagree to our Privacy Policy and Terms of Service.")
                        .foregroundStyle(Color(red: 70/255, green: 70/255, blue: 73/255))
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        
                    } label: {
                        WhiteButtonView(buttonActive: $buttonActive, text: "Continue")
                            .onChange(of: phoneNumber) { oldValue, newValue in
                                if !newValue.isEmpty {
                                    buttonActive = true
                                } else if newValue.isEmpty {
                                    buttonActive = false
                                }
                            }
                    }
                    .disabled(phoneNumber.isEmpty ? true : false)
                }
            }
        }
        .sheet(isPresented: $showCountryList, content: {
            SelectCountryView(countryChosen: $country)
        })
        .environment(\.colorScheme, .dark)
    }
}

//#Preview {
//    EnterPhoneNumberView()
//}
