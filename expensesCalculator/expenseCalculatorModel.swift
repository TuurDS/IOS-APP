//
//  expenseCalculatorModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI

//START SHARED MODEL
class ExpenseCalculatorModel: ObservableObject {
    
    static let shared = ExpenseCalculatorModel()

    @Published var path = [String]()
    @Published var loginModel: LoginModel
    @Published var registerModel: RegisterModel
    @Published var eventsModel: EventsModel
    @Published var eventModel: EventModel
    @Published var eventDetailsModel: EventDetailsModel
    @Published var expenseModel: ExpenseModel
    @Published var reportModel: ReportModel

    private init() {
        self.path = []
        self.loginModel = LoginModel()
        self.registerModel = RegisterModel()
        self.eventsModel = EventsModel()
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
//END SHARED MODEL

//START LOGIN PAGE
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
        ExpenseCalculatorModel.shared.eventsModel = EventsModel()
        ExpenseCalculatorModel.shared.path.append("events")
    }
    
    func Logout() {
        //todo remove token
        ExpenseCalculatorModel.shared.navigateBack()
    }
    
}
//END LOGIN PAGE

//START REGISTER PAGE
class RegisterModel {
    var login: String
    var password: String
    var passwordConfirm: String
    var errorText: String
    var focusedField: String
    
    init() {
        self.login = ""
        self.password = ""
        self.passwordConfirm = ""
        self.errorText = ""
        self.focusedField = ""
    }
    
    func Register() {
        ExpenseCalculatorModel.shared.eventsModel = EventsModel()
        ExpenseCalculatorModel.shared.path.append("events")
    }

}
//END REGISTER PAGE

//START EVENTS PAGE
class EventsModel {
    var isPinned: Bool
    var items = [EventsModelItem]()
    
    init() {
        self.isPinned = false
        self.items = [
            EventsModelItem(title: "Title 1", number: "1", description: "Description 1", icon: "pin.fill", iconColor: .red, isPinned: true, id: "1"),
            EventsModelItem(title: "Title 2", number: "2", description: "Description 2", icon: "pin.fill", iconColor: .yellow, isPinned: false, id: "2"),
            EventsModelItem(title: "Title 3", number: "3", description: "Description 3", icon: "pin.fill", iconColor: .blue, isPinned: true, id: "3"),
            EventsModelItem(title: "Title 4", number: "4", description: "Description 4", icon: "pin.fill", iconColor: .green, isPinned: true, id: "4"),
            EventsModelItem(title: "Title 5", number: "5", description: "Description 5", icon: "pin.fill", iconColor: .purple, isPinned: false, id: "5")
        ]
    }
    
    func fetchEvent() {
        //todo
    }
    func addEvent() {
        //todo
    }
    func pinEvent(id:String) {
        //todo
    }
    func navigateToSingleEvent(id:String) {
        ExpenseCalculatorModel.shared.eventModel = EventModel(id:id)
        ExpenseCalculatorModel.shared.path.append("event")
    }
    
}

class EventsModelItem: Identifiable {
  var title: String
  var number: String
  var description: String
  var icon: String
  var iconColor: Color
  var isPinned: Bool
  var id: String

  init(title: String, number: String, description: String, icon: String, iconColor: Color, isPinned: Bool, id: String) {
    self.title = title
    self.number = number
    self.description = description
    self.icon = icon
    self.iconColor = iconColor
    self.isPinned = isPinned
    self.id = id
  }
}
//END EVENTS PAGE

//START EVENT PAGE
class EventModel {
    var id: String
    var name: String
    var description: String
    var items = [EventModelItem]()
    
    init(id:String) {
        self.id = id
        self.name = "testname"
        self.description = "random very long description i dont know wtf hahahaha yes ofc why not ey."
        self.items = [
            EventModelItem(amount: 12.99, person: "Jane", description: "Grocery Shopping", id: "1"),
            EventModelItem(amount: 56.34, person: "Bob", description: "Dinner at Restaurant", id: "2"),
            EventModelItem(amount: 78.45, person: "Alice", description: "Rent for August", id: "3"),
            EventModelItem(amount: 156.34, person: "Thomas", description: "Food", id: "4"),
            EventModelItem(amount: 72.49, person: "Jake", description: "Utilities", id: "5")
        ]
    }
    
    func navigateToEventDetails(id: String) {
        ExpenseCalculatorModel.shared.eventDetailsModel = EventDetailsModel(id: id)
        ExpenseCalculatorModel.shared.path.append("eventdetails")
    }

    func navigateToReport(id: String) {
        ExpenseCalculatorModel.shared.reportModel = ReportModel(id: id)
        ExpenseCalculatorModel.shared.path.append("report")
    }

    func navigateToExpense(id: String) {
        ExpenseCalculatorModel.shared.expenseModel = ExpenseModel(id: id)
        ExpenseCalculatorModel.shared.path.append("expense")
    }
    
    func deleteEvent(id: String) {
      // TODO
    }
    
    func addExpense() {
        
    }
    
    func removeExpense(id: String) {
        
    }
    
}

class EventModelItem: Identifiable {
  var amount: Double
  var person: String
  var description: String
  var id: String

  init(amount: Double, person: String, description: String, id: String) {
    self.amount = amount
    self.person = person
    self.description = description
    self.id = id
  }
}


//END EVENT PAGE

//START EVENTDETAILS PAGE
class EventDetailsModel {
    var id: String
    var newUser: String
    var eventname: String
    var eventdescription: String
    var persons = [EventDetailsModelPersons]()
    
    init(id: String) {
        self.id = ""
        self.eventname = ""
        self.eventdescription = ""
        self.newUser = ""
        self.persons = [
            EventDetailsModelPersons(name:"max",id:"1"),
            EventDetailsModelPersons(name:"tom",id:"2"),
            EventDetailsModelPersons(name:"jerry",id:"3"),
            EventDetailsModelPersons(name:"duncan",id:"4"),
            EventDetailsModelPersons(name:"james",id:"5"),
            EventDetailsModelPersons(name:"corey",id:"6")
        ]
    }
    
    func saveDetails() {
        //todo
    }
    func addPerson() {
        //todo
    }
}

class EventDetailsModelPersons: Identifiable {
    var name: String
    var id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}

//END EVENTDETAILS PAGE

//START EXPENSE PAGE
class ExpenseModel {
    
    var price: Double{
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    
    var description: String
    var splitType: String {
        didSet {
            if splitType == "equal" {
                distributeAmountEqual()
            }
        }
    }
    
    var date: Date
    var persons: [ExpensePerson]
    var id:String
    
    init(id:String) {
        self.price = 102.54
        self.description = "this is the description of the expense"
        self.splitType = "percentage"
        self.date = Date()
        self.persons = [
            ExpensePerson(name: "Alice", value: 30.20),
            ExpensePerson(name: "Bob", value: 30.20),
            ExpensePerson(name: "Eve", value: 42.14)
        ]
        self.id = id
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
        //todo
    }
    
}


class ExpensePerson: Identifiable {
    var value: Double
    var name: String
    
    init(name:String,value:Double) {
        self.name = name
        self.value = value
    }
}
//END EXPENSE PAGE


//START REPORT PAGE
class ReportModel {
    var id: String
    var reports: [SingleReport]
    
    init(id:String) {
        self.id = id
        self.reports = [
            SingleReport(from: "Alice",to: "Bob",amount: 14.68, id: "1"),
            SingleReport(from: "jNic",to: "leah",amount: 145.54, id: "2"),
            SingleReport(from: "jonas",to: "jeff",amount: 23.16, id: "3"),
            SingleReport(from: "thomas",to: "arthur",amount: 0.68, id: "4"),
        ]
    }
}

class SingleReport: Identifiable {
    var from: String
    var to: String
    var amount: Double
    var id: String
    
    init(from: String, to: String, amount: Double, id:String) {
        self.from = from
        self.to = to
        self.amount = amount
        self.id = id
    }
}
//END REPORT PAGE
