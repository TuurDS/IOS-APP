//
//  expenseCalculatorModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI

class ExpenseCalculatorModel: ObservableObject {
    
    static let shared = ExpenseCalculatorModel()

    @Published var path = [String]()
    @Published var loginModel: LoginModel

    private init() {
        self.path = []
        self.loginModel = LoginModel()
    }
    
    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
}



class LoginModel {
    var login: String
    var password: String
    var errorText: String
    var focusedField: String
    var isLoggedIn: Bool
      
    
    
    init() {
        self.login = ""
        self.password = ""
        self.errorText = ""
        self.focusedField = ""
        self.isLoggedIn = false
    }
    
    func Login() {
        isLoggedIn = true;
        ExpenseCalculatorModel.shared.path.append("events")
    }
    
}
