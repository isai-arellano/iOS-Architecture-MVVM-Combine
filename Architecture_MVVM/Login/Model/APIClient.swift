//
//  APIClient.swift
//  Architecture_MVVM
//
//  Created by Isaí Arellano on 20/11/24.
//

import Foundation

enum BackendError: String, Error {
    case invalidEmail = "Comprueba el email."
    case invalidPassword = "Comprueba la contraseña."
}

final class APIClient {
    func login(withEmail: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackendLogin(email: withEmail, password: password)
    }
}

//Backend:
func simulateBackendLogin(email: String, password: String) throws -> User {
    guard email == "isai@arellano.com" else {
        print("El user no es isai@arellano.com")
        throw BackendError.invalidEmail
    }
    
    guard password == "1234567890" else {
        print("La password no es 1234567890")
        throw BackendError.invalidPassword
    }
    print("Success")
    return .init(name: "Isaí", token: "token_12345", sessionStart: .now)
}
