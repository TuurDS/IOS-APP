//
//  Request.swift
//  expensesCalculator
//
//  Created by Tuur De Schepper on 07/01/2023.
//

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
