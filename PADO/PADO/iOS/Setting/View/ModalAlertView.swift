//
//  ModalAlertView.swift
//  PADO
//
//  Created by 황민채 on 1/16/24.
//
import SwiftUI

enum ModalAlertTitle: String {
    case cash = "캐시 지우기"
    case account = "계정 삭제"
    case signOut = "로그아웃"
}

enum ModalAlertSubTitle: String {
    case cash = "캐시를 지우면 일부 문제가 해결될 수 있습니다"
    case account = "한번 삭제된 계정은 복원되지 않습니다. 정말 삭제하시겠어요?"
    case signOut = "현재 계정에서 로그아웃 하시겠어요?"
}

enum ModalAlertRemove: String {
    case cash = "PADO 캐시 지우기"
    case account = "계정 삭제"
    case signOut = "로그아웃"
}

struct ModalAlertView: View {
    @State var width = UIScreen.main.bounds.width
    @State var height = UIScreen.main.bounds.height
    
    var showingCircleImage: Bool
    let mainTitle: ModalAlertTitle
    let subTitle: ModalAlertSubTitle
    let removeMessage: ModalAlertRemove
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack(spacing: 10) {
                    if showingCircleImage {
                        if let user = viewModel.currentUser {
                            CircularImageView(size: .medium, user: user)
                        }
                    } else {
                        Text(mainTitle.rawValue)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                    }
                    Text(subTitle.rawValue)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(Color.white)
                .font(.system(size: 14))
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
                            viewModel.needsDataFetch.toggle()
                        }
                        dismiss()
                        
                    case .signOut:
                        viewModel.signOut()
                        viewModel.needsDataFetch.toggle()
                        dismiss()
                    }
                } label: {
                    Text(removeMessage.rawValue)
                        .font(.system(size: 16))
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
                        .font(.system(size: 16))
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
