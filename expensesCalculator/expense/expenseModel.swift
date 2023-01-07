//
//  expenseModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

class ExpenseModel: ObservableObject {
    
    @Published var price: Double{
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    
    @Published var description: String
    @Published var splitType: String {
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    
    @Published var date: Date
    @Published var persons = [ExpensePerson]()
    @Published var paidPerson: Int
    @Published var showErrorPopup = false
    
    var id:String
    
    init(id:String) {
        self.id = id
        self.price = 0
        self.description = ""
        self.splitType = ""
        self.paidPerson = 0
        self.date = Date()
        if(id != "") {
            updateUI()
        }
    }
    
    func updateUI() {
        let eventData = ExpenseCalculatorModel.shared.eventModel.eventData!
        let expense = eventData.expenses.first(where: { $0.id == self.id })!
        
        self.price = expense.amount
        self.description = expense.expenseDescription
        self.splitType = expense.splitType
        print(String(expense.date))
        print(Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let index = expense.date.index(expense.date.startIndex, offsetBy: 10)
        self.date = dateFormatter.date(from:String(expense.date[..<index]))!
        self.paidPerson = eventData.people.firstIndex(where: { $0.id == expense.paid.id })!
        self.persons = expense.includedPersons.map { person -> ExpensePerson in
            let value = person.value
            let name = person.name
            return ExpensePerson(name: name, value: value)
        }
        
        for person in eventData.people {
            if !self.persons.contains(where: { $0.name == person.name }) {
                self.persons.append(ExpensePerson(name: person.name, value: 0))
            }
        }
    }


    
    func distributeAmountEqual() {
        let totalAmount = self.price
        let numPersons = self.persons.count
        let equalAmount = totalAmount / Double(numPersons)

        for person in self.persons {
            person.value = equalAmount
        }
    }
    
    func saveExpense() {
        let body = UpdateExpenseBody(id: self.id, updateExpenseBodyDescription: self.description, amount: self.price, date: self.date.description, splitType: self.splitType, paidname: self.persons[self.paidPerson].name,
            includedPersons: self.persons.map { person -> ExpenseIncludedPerson in
                let value = person.value
                let name = person.name
                return ExpenseIncludedPerson(name: name, value: value)
            }
        )

        // Encode the EventDetailsBody instance to JSON data
        let bodyData = try? JSONEncoder().encode(body)

        ExpenseCalculatorModel.request.send(method: .put, path: "event/expense", body: bodyData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    ExpenseCalculatorModel.shared.eventModel.fetchEventData()
                    ExpenseCalculatorModel.shared.navigateBack()
                case .failure(let error):
                    print("Error saving expense changes: \(error)")
                    self.showErrorPopup = true;
                }
            }
        }
    }
    
}

// MARK: UI-OBJECTS
class ExpensePerson: Identifiable {
    var value: Double
    var name: String
    
    init(name:String,value:Double) {
        self.name = name
        self.value = value
    }
}

// MARK: DTO's
struct UpdateExpenseBody: Codable {
    let id, updateExpenseBodyDescription: String
    let amount: Double
    let date, splitType, paidname: String
    let includedPersons: [ExpenseIncludedPerson]

    enum CodingKeys: String, CodingKey {
        case id
        case updateExpenseBodyDescription = "description"
        case amount, date, splitType, paidname, includedPersons
    }
}

struct ExpenseIncludedPerson: Codable {
    let name: String
    let value: Double
}
