//
//  HomeDetailViewModel.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 12.11.2022.
//

import Foundation
import UIKit
import Kingfisher

final class HomeDetailViewModel {
    
    public func getMovie(id: Int?, image: UIImageView, point: UILabel, date: UILabel, title: UILabel, description: UILabel) {
        Webservice.shared.getMovie(id: id) { response in
            switch response {
                case .success(let movie):
                    guard let backdropPath = movie.backdrop_path else {
                        return
                    }
                    guard let imageUrl = URL(string: "\(Constant.IMAGE_PATH)\(backdropPath)") else {
                        return
                    }
                    DispatchQueue.main.async {
                        image.kf.setImage(with: imageUrl)
                        point.text = String(format: "%.1f", Double(movie.vote_average ?? 0))
                        date.text = Helpers.shared.dateFormat(movie.release_date, format: "dd.MM.yyyy")
                        title.text = "\(String(describing: movie.title ?? "")) (\(Helpers.shared.dateFormat(movie.release_date, format: "yyyy")))"
                        description.text = movie.overview
                    }
                case .failure(_):
                    break;
            }
        }
    }
}
