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
    
    func send(method: Method, path: String, body: Data? = nil, completion: @escaping (Result<Any, Error>) -> Void) {
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
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.success(json))
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
class EventModel:ObservableObject  {
    var id: String
    @Published var name: String
    @Published var description: String
    @Published var items = [EventModelItem]()
    
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
class EventDetailsModel:ObservableObject  {
    var id: String
    @Published var newUser: String
    @Published var eventname: String
    @Published var eventdescription: String
    @Published var persons = [EventDetailsModelPersons]()
    
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
    @Published var persons: [ExpensePerson]
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
        self.description = "test"
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
