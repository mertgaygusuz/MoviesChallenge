//
//  Upcoming.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation

struct Upcoming: Codable {
    var dates: UpcomingDates?
    var page: Int?
    var results: [UpcomingResults]?
    var total_pages: Int?
    var total_results: Int?
}

struct UpcomingDates: Codable {
    var maximum: String?
    var minimum: String?
}

struct UpcomingResults: Codable {
    var backdrop_path: String?
    var id: Int?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
}
