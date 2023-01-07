//
//  reportModel.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

import Foundation

class ReportModel:ObservableObject {
    var id: String
    @Published var reports = [SingleReport]()
    
    init(id:String) {
        self.id = id
        if(id != "") {
            self.fetchReport()
        }
    }
    
    func fetchReport() {
        ExpenseCalculatorModel.request.send(method: .get, path: "event/report/\(self.id)", decodeJson: false) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    let decoder = JSONDecoder()
                    do {
                        let reportReturnBody = try decoder.decode(ReportReturnBody.self, from: json as! Data)
                        let singleReports = reportReturnBody.map { SingleReport(from: $0.from, to: $0.to, amount: $0.amount, id: UUID().uuidString) }
                        self.reports = singleReports
                    } catch {
                        print("Error: Could not decode JSON data: \(error)")
                    }

                case .failure(let error as NSError):
                    print(error)
                }
            }
        }
    }
}


// MARK: UI-OBJECTS
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


// MARK: DTO's
struct ReportReturnBodyElement: Codable {
    let from, to: String
    let amount: Double
}

typealias ReportReturnBody = [ReportReturnBodyElement]
