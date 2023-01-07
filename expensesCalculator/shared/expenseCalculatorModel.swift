//
//  expenseCalculatorModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI
import Foundation

//START SHARED MODEL
class ExpenseCalculatorModel: ObservableObject {
    
    static let shared = ExpenseCalculatorModel()

    @Published var path = [String]()
    @ObservedObject var loginModel: LoginModel
    @ObservedObject var registerModel: RegisterModel
    @ObservedObject var eventsModel: EventsModel
    @ObservedObject var eventModel: EventModel
    @ObservedObject var eventDetailsModel: EventDetailsModel
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var reportModel: ReportModel
    
    static let request = Request()
    
    private init() {
        self.path = []
        self.loginModel = LoginModel()
        self.registerModel = RegisterModel()
        self.eventsModel = EventsModel(canFetch: false)
        self.eventModel = EventModel(id: "")
        self.eventDetailsModel = EventDetailsModel(id: "")
        self.expenseModel = ExpenseModel(id: "")
        self.reportModel = ReportModel(id: "")
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
