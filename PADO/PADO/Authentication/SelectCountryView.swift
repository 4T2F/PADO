//
//  SelectCountryView.swift
//  BeReal
//
//  Created by 강치우 on 1/2/24.
//

import SwiftUI

struct SelectCountryView: View {
    
    var countries: [Country] = Country.allCountries
    
    @Binding var countryChosen: Country
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("국가 선택")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    VStack {
                        List {
                            Section {
                                ForEach(countries, id: \.isoCode) { country in
                                    HStack {
                                        Text("\(country.flag(country: country.isoCode)) \(country.localizedName) (+\(country.phoneCode))")
                                        
                                        Spacer()
                                        
                                        if country.isoCode == countryChosen.isoCode {
                                            Image(systemName: "checkmark.circle")
                                        }
                                    }
                                    .onTapGesture {
                                        countryChosen = country
                                        dismiss()
                                    }
                                }
                            } header: {
                                Text("SUGGESTED")
                                    .padding(.leading, -8)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
                .padding(.top, 50)
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
