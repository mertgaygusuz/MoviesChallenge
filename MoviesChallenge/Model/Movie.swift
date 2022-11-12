//
//  Movie.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation

struct Movie: Codable {
    var backdrop_path: String?
    var id: Int?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
}
