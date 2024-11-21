//
//  LoginViewModel.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 20/11/24.
//

import Foundation
import Combine
//Cuando se utiliza SwiftUI, tenemos que agregarle : ObservableObject al ViewModel para que pueda ser observado por la vista.
class LoginViewModel: ObservableObject {
    //Binding
    @Published var email = ""
    @Published var password = ""
    @Published var isEnabled = false
    @Published var showLoading = false
    @Published var errorMessage = ""
    @Published var userModel: User?
    
    //Navegación implementada con SwiftUI
    @Published var pathNavigation: [String] = []
    
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
                //Navegación implementada con SwiftUI:
                pathNavigation.append("home")
            } catch let error as BackendError {
                errorMessage = error.rawValue
                print(error.localizedDescription)
            }
            showLoading = false
        }
    }
}

