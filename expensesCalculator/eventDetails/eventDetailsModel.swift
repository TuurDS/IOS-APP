//
//  eventDetailsModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

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

// MARK: UI-OBJECTS
class EventDetailsModelPersons: Identifiable {
    var name: String
    var id: String
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}

// MARK: DTO's
struct EventDetailsBody: Codable {
    let id, name, eventDetailsBodyDescription: String
    let people: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case eventDetailsBodyDescription = "description"
        case people = "People"
    }
}
