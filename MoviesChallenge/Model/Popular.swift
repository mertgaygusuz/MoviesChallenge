//
//  Popular.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation

struct Popular: Codable {
    var dates: PopularDates?
    var page: Int?
    var results: [PopularResults]?
    var total_pages: Int?
    var total_results: Int?
}

struct PopularDates: Codable {
    var maximum: String?
    var minimum: String?
}

struct PopularResults: Codable {
    var backdrop_path: String?
    var id: Int?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
}
