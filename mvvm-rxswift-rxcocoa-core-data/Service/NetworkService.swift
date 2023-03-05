//
//  NetworkService.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit
import RxSwift

enum Environment: String {
    case staging = "Staging"
    case production = "Production"
    case local = "Local"
    
    func url(_ path: String) -> URL? {
        guard let plistPath = Bundle.main.path(forResource: self.rawValue, ofType: "plist"),
              let plistData = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil),
              let url = (plist as? [String: Any])?["url"] as? String else {
            return nil
        }
        return URL(string: url + path)
    }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case OPTIONS
}

enum NetworkError: Error {
    case serializationError
}

struct Empty: Codable { }

protocol NetworkProtocol {
    associatedtype T: Codable
    associatedtype R: Decodable
    
    func send(env: Environment, method: HttpMethod, path: String, request: T?, debuggable: Bool) -> Observable<R>
}

final class NetworkService<Request: Codable, Response: Decodable> : NetworkProtocol {
    
    typealias T = Request
    
    typealias R = Response
    
    func send(env: Environment = .staging, method: HttpMethod = .GET, path: String,request: Request? = nil, debuggable: Bool = true ) -> Observable<Response> {
        
        return Observable.create { observable in
            var httpRequest = URLRequest(url: env.url(path)!)
            httpRequest.httpMethod = method.rawValue
           
            if let body = request {
                httpRequest.httpBody = try? JSONEncoder().encode(body)
            }
            
            let task = URLSession.shared.dataTask(with: httpRequest) { [weak self]  data, response, error in
                guard let data = data, error ==  nil else { return }
                
                do {
                    if let raw = String(data: data, encoding: .utf8), debuggable { print("\(raw)") }
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    observable.onNext(response)
                } catch {
                    observable.onError(NetworkError.serializationError)
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
