//
//  ViewController.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 20/11/24.
//

import UIKit
import Combine

class LoginView: UIViewController {
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    var cancellables = Set<AnyCancellable>()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.subtitle = "Login with your credentials"
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { action in
            self.startLogin()
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
            label.text = ""
            label.numberOfLines = 0
            label.textColor = .red
            label.font = .systemFont(ofSize: 20, weight: .regular, width: .condensed)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Crear Binding
        createBindingViewWithViewModel()
        // Agregar las subvistas a la vista.
        [emailTextField, passwordTextField,loginButton,errorLabel].forEach(view.addSubview)
        // Agregar constrains para visualizar correctamente las subvistas.
        NSLayoutConstraint.activate([
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
        
    }
    
    private func startLogin() {
        loginViewModel.userLogin(email: emailTextField.text?.lowercased() ?? "", password: passwordTextField.text?.lowercased() ?? "")
    }
    
    //Binding
    func createBindingViewWithViewModel(){
        emailTextField.textPublisher
            .assign(to: \LoginViewModel.email, on: loginViewModel)
            .store(in: &cancellables)
        passwordTextField.textPublisher
            .assign(to: \LoginViewModel.password, on: loginViewModel)
            .store(in: &cancellables)
        //Se conecta a la propiedad $isEnabled de viewModel con .isEnabled de la subvista : loginButton
        loginViewModel.$isEnabled
            .assign(to: \.isEnabled , on: loginButton)
            .store(in: &cancellables)
        
        //Se conecta la proiedad $showLoading de viewModel con .configuration de la subvista: loginButton
        loginViewModel.$showLoading
            .assign(to: \.configuration!.showsActivityIndicator, on: loginButton)
            .store(in: &cancellables)
        
        //Se conecta la proiedad $errorMessage de viewModel con UILabel.text de la subvista: errorLabel
        loginViewModel.$errorMessage
            .assign(to: \UILabel.text!, on: errorLabel)
            .store(in: &cancellables)
        
        //Navegación : Se conecta userModel y cuando hay un cambio el se ejecuta .sink y la logica que tenga dentro.
        loginViewModel.$userModel.sink { [weak self] _ in
            print("Navegación correcta hacía HomeView")
            let homeView = HomeView()
            self?.present(homeView, animated: true)
        }.store(in: &cancellables)
            
    }


}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}

