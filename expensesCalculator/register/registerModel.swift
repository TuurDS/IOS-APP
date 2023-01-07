//
//  registerModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

class RegisterModel:ObservableObject  {
    @Published var login: String
    @Published var password: String
    @Published var passwordConfirm: String
    @Published var errorText: String
    @Published var focusedField: String
    
    init() {
        self.login = ""
        self.password = ""
        self.passwordConfirm = ""
        self.errorText = ""
        self.focusedField = ""
    }
    
    func Register() {
        // Check if the password and passwordConfirm fields are filled in
        if password.isEmpty || passwordConfirm.isEmpty {
            self.errorText = "Please enter a password and confirm it."
            return
        }

        // Check if the password and passwordConfirm fields are equal
        if password != passwordConfirm {
            self.errorText = "The passwords do not match."
            return
        }

        let body = LoginRegisterRequestBody(name: login, password: password)
        let bodyData = try? JSONEncoder().encode(body)

        ExpenseCalculatorModel.request.send(method: .post, path: "user/register", body: bodyData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    // handle success case
                    if let json = json as? [String: Any], let token = json["token"] as? String {
                        ExpenseCalculatorModel.request.setToken(token: token)
                        ExpenseCalculatorModel.shared.eventsModel = EventsModel(canFetch: true)
                        ExpenseCalculatorModel.shared.path.append("events")
                        self.errorText = ""
                    } else {
                        self.errorText = "Invalid response from server"
                    }
                case .failure(let error as NSError):
                    self.errorText = error.domain
                }
            }
        }
    }
}

//uses json for return and login/register object so no dto's 
