//
//  LoginViewBySwiftUI.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 21/11/24.
//
import SwiftUI

struct LoginViewBySwiftUI: View {
    @StateObject private var viewModel = LoginViewModel(apiClient: APIClient())
    
    var body: some View {
        NavigationStack(path: $viewModel.pathNavigation) {
            VStack(spacing: 20) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal, 32)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 32)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Button(action: {
                    viewModel.userLogin(email: viewModel.email, password: viewModel.password)
                }) {
                    HStack {
                        if viewModel.showLoading {
                            ProgressView()
                        }
                        Text("Login")
                            .bold()
                    }
                }
                .disabled(!viewModel.isEnabled)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 32)
                navigationDestination(for: String.self) { destination in
                       if destination == "home" {
                        HomeViewBySwiftUI()
                  }
               }
            }
        }
    }
    
}
