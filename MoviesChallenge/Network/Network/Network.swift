//
//  Network.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation
import Alamofire

final class Network {
    static let shared = Network()
}

extension Network {
    func request<T: Codable>(url: URL?, excepting: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        guard let url = url else { return }
        AF.request(url).responseDecodable(of: excepting.self) { response in
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
