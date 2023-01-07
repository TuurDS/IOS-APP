//
//  LoginModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

class LoginModel:ObservableObject  {
    @Published var login: String
    @Published var password: String
    @Published var errorText: String
    @Published var focusedField: String
    var isLoggedIn: Bool
    
    init() {
        self.login = ""
        self.password = ""
        self.errorText = ""
        self.focusedField = ""
        self.isLoggedIn = false
    }
    
    func Login() {
        let body = LoginRegisterRequestBody(name: login, password: password)
        let bodyData = try? JSONEncoder().encode(body)
        
        ExpenseCalculatorModel.request.send(method: .post, path: "user/login", body: bodyData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    // handle success case
                    if let json = json as? [String: Any], let token = json["token"] as? String {
                        ExpenseCalculatorModel.request.setToken(token: token)
                        self.isLoggedIn = true
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

    func Logout() {
        isLoggedIn = false
        ExpenseCalculatorModel.request.setToken(token: "")
        ExpenseCalculatorModel.shared.navigateBack()
    }
    
    
    
}

// MARK: UI-OBJECTS
struct LoginRegisterRequestBody: Codable {
    var name: String = ""
    var password: String = ""
}
