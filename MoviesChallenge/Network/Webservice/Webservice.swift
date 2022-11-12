//
//  Webservice.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation
import Alamofire

final class Webservice {
    static let shared = Webservice()
    
    public func getPopularMovies(page: Int?, completion: @escaping (Result<Popular, AFError>) -> Void) {
        guard let page = page else { return }
        let urlString = "\(Constant.BASE_URL)\(Constant.POPULAR)\(Constant.API_KEY)\(Constant.LANGUAGE)\(Constant.PAGES)\(page)"
        let url = URL(string: urlString)
        
        Network.shared.request(url: url, excepting: Popular.self) { response in
            switch response {
                case .success(let movies):
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func getUpcomingMovies(page: Int?, completion: @escaping (Result<Upcoming, AFError>) -> Void) {
        guard let page = page else { return }
        let urlString = "\(Constant.BASE_URL)\(Constant.UPCOMING)\(Constant.API_KEY)\(Constant.LANGUAGE)\(Constant.PAGES)\(page)"
        let url = URL(string: urlString)
        
        Network.shared.request(url: url, excepting: Upcoming.self) { response in
            switch response {
                case .success(let movies):
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func getMovie(id: Int?, completion: @escaping (Result<Movie, AFError>) -> Void) {
        guard let id = id else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        let urlString = "\(Constant.BASE_URL)\(Constant.DETAIL)\(id)\(Constant.API_KEY)\(Constant.LANGUAGE)"
        let url = URL(string: urlString)
        Network.shared.request(url: url, excepting: Movie.self) { response in
            switch response {
                case .success(let movie):
                    completion(.success(movie))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
