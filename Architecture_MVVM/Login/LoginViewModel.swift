//
//  LoginViewModel.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 20/11/24.
//

import Foundation
import Combine

class LoginViewModel {
    //Binding
    @Published var email = ""
    @Published var password = ""
    @Published var isEnabled = false
    @Published var showLoading = false
    @Published var errorMessage = ""
    @Published var userModel: User?
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient){
        self.apiClient = apiClient
        formValidation()
    }

    func formValidation() {
        //Binding combinando dos publishers.
        Publishers.CombineLatest($email, $password)
            .filter { email, password in
                return email.count > 5 && password.count > 5
            }
            .sink { value in
                self.isEnabled = true
            }
            .store(in: &cancellables)
        
        //Binding normal propiedad por propiedad:
//        $email
//            .filter { $0.count > 5 }
//            .receive(on:  DispatchQueue.main)
//            .sink { value in
//                self.isEnabled = true
//            }.store(in: &cancellables)
//        $password
//            .filter { $0.count > 5 }
//            .receive(on:  DispatchQueue.main)
//            .sink { value in
//                self.isEnabled = true
//            }.store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(email: String, password: String) {
            errorMessage = ""
            showLoading = true
        Task {
            do {
                userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as BackendError {
                errorMessage = error.rawValue
                print(error.localizedDescription)
            }
            showLoading = false
        }
    }
}

