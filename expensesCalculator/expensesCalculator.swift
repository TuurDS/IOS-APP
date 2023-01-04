//
//  expensesCalculator.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 29/12/2022.
//

import SwiftUI

@main
struct expensesCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            Login().environmentObject(ExpenseCalculatorModel.shared)
        }
    }
}
