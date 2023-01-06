//
//  expenseCalculatorModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 04/01/2023.
//

import SwiftUI

//START REQUEST CLASS
import Foundation

class Request {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let baseURL: URL = URL(string:"http://192.168.2.130:5000/api/")!
    var token: String = ""
    
    func setToken(token: String) {
        self.token = token
    }
    
    func send(method: Method, path: String, body: Data? = nil, decodeJson: Bool = true, completion: @escaping (Result<Any, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != "" {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            if response.statusCode >= 400 {
                // handle error case
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any], let message = json["message"] as? String {
                    completion(.failure(NSError(domain: message, code: response.statusCode, userInfo: nil)))
                } else {
                    completion(.failure(NSError(domain: "Unknown error", code: response.statusCode, userInfo: nil)))
                }
            } else {
                // handle success case
                do {
                    if(decodeJson) {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(.success(json))
                    } else {
                        completion(.success(data))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


//END REQUEST CLASS

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
//END SHARED MODEL

//START LOGIN PAGE
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
struct LoginRegisterRequestBody: Codable {
    var name: String = ""
    var password: String = ""
}

//END LOGIN PAGE

//START REGISTER PAGE
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
//END REGISTER PAGE

//START EVENTS PAGE
class EventsModel:ObservableObject {
    @Published var items = [EventsModelItem]()
    @Published var isPinned: Bool{
        didSet {
            filterItems()
        }
    }
    @Published var fetchedItems = [EventsModelItem]() {
        didSet {
            filterItems()
        }
    }

    
    init(canFetch:Bool) {
        self.isPinned = true
        if(canFetch) {
            fetchEvents()
        }
    }
    
    func filterItems() {
        if isPinned {
            items = fetchedItems.filter { $0.isPinned }
        } else {
            items = fetchedItems.filter { !$0.isPinned }
        }
    }

    
    func fetchEvents() {
        ExpenseCalculatorModel.request.send(method: .get, path: "event") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    // handle success case
                    if let json = json as? [[String: Any]] {
                        self.fetchedItems = json.map {
                            let id = $0["id"] as? String ?? ""
                            let name = $0["name"] as? String ?? ""
                            let description = $0["description"] as? String ?? ""
                            let pinned = $0["pinned"] as? Bool ?? false
                            return EventsModelItem(title: name, description: description,
                                                   icon: "pin.fill", isPinned: pinned, id: id)
                       }
                        
                    } else {
                       print("there was an error while trying to parse the response")
                    }
                case .failure(let error as NSError):
                   print(error)
                }
            }
        }
    }
    
    func addEvent() {
        ExpenseCalculatorModel.request.send(method: .post, path: "event") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    // handle success case
                    if let json = json as? [String: Any], let eventId = json["eventId"] as? String {
                        self.fetchEvents()
                        ExpenseCalculatorModel.shared.eventModel = EventModel(id:eventId)
                        ExpenseCalculatorModel.shared.path.append("event")
                    } else {
                        print("there was an error while trying to parse the response")
                    }
                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }


    
    func pinEvent(id: String) {
        if let index = self.fetchedItems.firstIndex(where: { $0.id == id }) {
            let body = PinEventBody(id: id, pinned: !self.fetchedItems[index].isPinned)
            let bodyData = try? JSONEncoder().encode(body)

            ExpenseCalculatorModel.request.send(method: .put, path: "event/pin", body: bodyData) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        // refresh the view
                        self.fetchEvents()
                    case .failure(let error as NSError):
                        print(error)
                    }
                }
            }
        }
    }

    
    func navigateToSingleEvent(id:String) {
        ExpenseCalculatorModel.shared.eventModel = EventModel(id:id)
        ExpenseCalculatorModel.shared.path.append("event")
    }
}

struct CreateEvent: Codable {
    let message, eventID: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case message
        case eventID = "eventId"
        case status
    }
}


struct PinEventBody: Codable {
    let id: String
    let pinned: Bool
}

struct AllEvent: Codable {
    let id, name, allEventDescription: String
    let pinned: Bool
    let createdAt, updatedAt, userID: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case allEventDescription = "description"
        case pinned, createdAt, updatedAt
        case userID = "UserId"
    }
}

typealias AllEvents = [AllEvent]


class EventsModelItem: Identifiable {
    @Published var title: String
    @Published var description: String
    @Published var icon: String
    @Published var isPinned: Bool
    var id: String

  init(title: String, description: String, icon: String, isPinned: Bool, id: String) {
    self.title = title
    self.description = description
    self.icon = icon
    self.isPinned = isPinned
    self.id = id
  }
}
//END EVENTS PAGE

//START EVENT PAGE
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

// MARK: - Expense
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

// MARK: - IncludedPerson
struct IncludedPerson: Codable {
    let id, name: String
    let value: Double
}

// MARK: - Person
struct PersonData: Codable {
    let name, id: String
}

//END EVENT PAGE

//START EVENTDETAILS PAGE
class EventDetailsModel:ObservableObject  {
    var id: String
    @Published var newUser: String
    @Published var eventname: String
    @Published var eventdescription: String
    @Published var persons = [EventDetailsModelPersons]()
    
    init(id: String) {
        self.id = id
        self.newUser = ""
        self.eventname = ""
        self.eventdescription = ""
        if(id != "") {
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.eventname = ExpenseCalculatorModel.shared.eventModel.eventData!.name
        self.eventdescription = ExpenseCalculatorModel.shared.eventModel.eventData!.eventDataDescription
        self.persons = ExpenseCalculatorModel.shared.eventModel.eventData!.people.map { person in
            EventDetailsModelPersons(name: person.name, id: person.id)
        }
    }
    
    func saveDetails() {
        // Create an instance of EventDetailsBody
        let body = EventDetailsBody(id: self.id, name: self.eventname, eventDetailsBodyDescription: self.eventdescription, people: self.persons.map { $0.name })
        
        // Encode the EventDetailsBody instance to JSON data
        let bodyData = try? JSONEncoder().encode(body)
        
        // Send a PUT request to the /event/details endpoint with the JSON data as the request body
        ExpenseCalculatorModel.request.send(method: .put, path: "event/details", body: bodyData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    ExpenseCalculatorModel.shared.eventsModel.fetchEvents()
                    ExpenseCalculatorModel.shared.eventModel.fetchEventData()
                    ExpenseCalculatorModel.shared.navigateBack()
                case .failure(let error):
                    print("Error saving event details: \(error)")
                }
            }
        }
    }

    
    func addPerson() {
        guard !newUser.isEmpty, newUser.count >= 4 else {
            return
        }
        
        let newPersonId = UUID().uuidString
        let newPerson = EventDetailsModelPersons(name: newUser, id: newPersonId)
        persons.append(newPerson)
        newUser = ""
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

struct EventDetailsBody: Codable {
    let id, name, eventDetailsBodyDescription: String
    let people: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDetailsBodyDescription = "description"
        case people = "People"
    }
}
//END EVENTDETAILS PAGE

//START EXPENSE PAGE
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

// MARK: - IncludedPerson
struct ExpenseIncludedPerson: Codable {
    let name: String
    let value: Double
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
class ReportModel:ObservableObject {
    var id: String
    @Published var reports: [SingleReport]
    
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
