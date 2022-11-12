//
//  HomeCollectionViewCell.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 12.11.2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    
    private let movieImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var movieTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var movieDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfigure()
        configureConstraints()
    }
    
    private func viewConfigure() {
        contentView.addSubview(movieImage)
        contentView.addSubview(movieTitle)
        contentView.addSubview(movieDescription)
    }
    
    private func configureConstraints() {
        movieImageConstraints()
        movieTitleConstraints()
        movieDescriptionConstraints()
    }
    
    private func movieImageConstraints() {
        movieImage.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(50)
        }
    }
    
    private func movieTitleConstraints() {
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(152)
            make.right.equalTo(-16)
            make.left.equalTo(16)
        }
    }
    
    private func movieDescriptionConstraints() {
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(8)
            make.right.equalTo(-16)
            make.left.equalTo(16)
        }
    }
    
    public func set(_ popular: PopularResults) {
        guard let backdropPath = popular.backdrop_path else {
            return
        }
        guard let imageUrl = URL(string: "\(Constant.IMAGE_PATH)\(backdropPath)") else {
            return
        }
        DispatchQueue.main.async {
            self.movieImage.kf.setImage(with: imageUrl)
            self.movieTitle.text = "\(String(describing: popular.title ?? "")) (\(Helpers.shared.dateFormat(popular.release_date, format: "yyyy")))"
            self.movieDescription.text = popular.overview
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) error occurred")
    }
}
