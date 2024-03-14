//
//  ModalAlertView.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//

import SwiftUI

struct ModalAlertView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    var showingCircleImage: Bool
    let mainTitle: ModalAlertTitle
    let subTitle: ModalAlertSubTitle
    let removeMessage: ModalAlertRemove
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    if showingCircleImage {
                        if let user = viewModel.currentUser {
                            CircularImageView(size: .medium, 
                                              user: user)
                        }
                    } else {
                        Text(mainTitle.rawValue)
                            .font(.system(.body))
                            .fontWeight(.semibold)
                    }
                    Text(subTitle.rawValue)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(Color.white)
                .font(.system(.subheadline))
                .fontWeight(.medium)
                .padding()
                
                Divider()
                
                Button {
                    switch removeMessage {
                    case .cash:
                        let fileManager = FileManager.default
                        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                            do {
                                let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
                                for file in files {
                                    try fileManager.removeItem(at: file)
                                }
                                print("캐시가 성공적으로 지워졌습니다.")
                            } catch {
                                print("캐시를 지우는데 실패했습니다: \(error)")
                            }
                        }
                        dismiss()
                        
                    case .account:
                        Task {
                            await viewModel.deleteAccount()
                            needsDataFetch.toggle()
                        }
                        dismiss()
                        
                    case .signOut:
                        Task {
                            viewModel.signOut()
                            try? await Task.sleep(nanoseconds: 1 * 500_000_000)
                            needsDataFetch.toggle()
                        }
                        dismiss()
                    }
                } label: {
                    Text(removeMessage.rawValue)
                        .font(.system(.body))
                        .foregroundStyle(Color.red)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
                .padding(.bottom, 5)
            }
            .frame(width: width * 0.9)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 22))
            
            VStack {
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(.body))
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .frame(width: width * 0.9, height: 40)
                }
            }
            .frame(width: width * 0.9, height: 50)
            .background(Color.modal)
            .clipShape(.rect(cornerRadius: 12))
        }
        .background(ClearBackground())
    }
}
