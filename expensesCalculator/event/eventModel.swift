//
//  eventModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

class EventModel:ObservableObject {
    var id: String
    @Published var name: String
    @Published var description: String
    @Published var items = [EventModelItem]()
    
    var eventData: EventData?
    
    init(id:String) {
        self.id = id
        self.name = ""
        self.description = ""
        self.eventData = nil
        if(id != "") {
            self.fetchEventData()
        }
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
    
    func fetchEventData() {
        ExpenseCalculatorModel.request.send(method: .get, path: "event/\(self.id)", decodeJson: false) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    let decoder = JSONDecoder()
                    do {
                        self.eventData = try decoder.decode(EventData.self, from: json as! Data)
                        self.parseEventData()
                    } catch {
                        print("Error: Could not decode JSON data: \(error)")
                    }
                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }
    
    func parseEventData() {
        let eventData = self.eventData!
        self.name = eventData.name
        self.description = eventData.eventDataDescription
        self.items = eventData.expenses.map { event in
            EventModelItem(amount: event.amount, person: event.paid.name, description: event.expenseDescription, id: event.id)
        }
    }
        
    func deleteEvent(id: String) {
        ExpenseCalculatorModel.request.send(method: .delete, path: "event/\(id)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    ExpenseCalculatorModel.shared.eventsModel.fetchEvents()
                    ExpenseCalculatorModel.shared.navigateBack()
                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }
    
    func addExpense() {
        ExpenseCalculatorModel.request.send(method: .post, path: "event/expense/\(self.id)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.fetchEventData()
                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }
    
    func deleteExpense(id: String) {
        ExpenseCalculatorModel.request.send(method: .delete, path: "event/expense/\(id)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.fetchEventData()
                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }
        
}


// MARK: UI-OBJECTS
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


// MARK: DTO's
struct EventData: Codable {
    let id, name, eventDataDescription, userID: String
    let people: [PersonData]
    let expenses: [ExpenseData]

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDataDescription = "description"
        case userID = "UserId"
        case people = "People"
        case expenses = "Expenses"
    }
}

struct ExpenseData: Codable {
    let id, expenseDescription: String
    let amount: Double
    let date, splitType: String
    let paid: PersonData
    let includedPersons: [IncludedPerson]

    enum CodingKeys: String, CodingKey {
        case id
        case expenseDescription = "description"
        case amount, date, splitType, paid, includedPersons
    }
}

struct IncludedPerson: Codable {
    let id, name: String
    let value: Double
}

struct PersonData: Codable {
    let name, id: String
}
