//
//  eventModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

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


// MARK: UI-OBJECTS
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


// MARK: DTO's
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



