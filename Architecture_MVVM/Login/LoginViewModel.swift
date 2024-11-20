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
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient){
        self.apiClient = apiClient
        formValidation()
    }

    func formValidation() {
        //Binding
        $email
            .sink { value in
                print("Email: \(value) ")
            }.store(in: &cancellables)
        $password
            .sink { value in
                print("Password: \(value) ")
            }.store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(email: String, password: String) {
        Task {
            do {
              let userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as BackendError {
                print(error.localizedDescription)
            }
        }
    }
}

