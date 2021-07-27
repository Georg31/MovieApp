//
//  WebService.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/11/21.
//

import UIKit
import Alamofire

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case AFError
}

struct Resource<T: Codable> {
    let url: URL
}

class Webservice {

    static func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = URLRequest(url: resource.url)
        AF.request(request).response { resp in
            if case .success(let data) = resp.result {
                if let result = try? JSONDecoder().decode(T.self, from: data!) {
                    completion(.success(result))
                } else {
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.AFError))
            }
        }
    }
}
