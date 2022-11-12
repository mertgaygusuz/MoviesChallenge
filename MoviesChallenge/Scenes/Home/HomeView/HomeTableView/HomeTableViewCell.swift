//
//  HomeTableViewCell.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 12.11.2022.
//

import UIKit
import Kingfisher
import SnapKit

class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    
    private let movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let movieTitle: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private var movieDescription: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textColor = .gray
        return label
    }()
    
    private var movieDate: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfigure()
        configureConstraints()
    }
    
    private func viewConfigure() {
        contentView.backgroundColor = .white
        contentView.addSubview(movieImage)
        contentView.addSubview(movieTitle)
        contentView.addSubview(movieDescription)
        contentView.addSubview(movieDate)
    }
    
    private func configureConstraints() {
        movieımageConstraints()
        movieTitleConstraints()
        movieDescriptionConstraints()
        movieDateConstraints()
    }
    
    private func movieımageConstraints() {
        movieImage.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.bottom.equalTo(-16)
            make.width.height.equalTo(80)
        }
    }
    
    private func movieTitleConstraints() {
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(24)
            make.left.equalTo(movieImage.snp.right).offset(8)
            make.right.equalTo(-44)
        }
    }
    
    private func movieDescriptionConstraints() {
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(8)
            make.left.equalTo(movieImage.snp.right).offset(8)
            make.right.equalTo(-20)
        }
    }
    
    private func movieDateConstraints() {
        movieDate.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(16)
            make.bottom.equalTo(16)
            make.right.equalTo(-20)
        }
    }
    
    public func set(_ upcoming: UpcomingResults) {
        guard let posterPath = upcoming.poster_path else {
            return
        }
        guard let imageUrl = URL(string: "\(Constant.IMAGE_PATH)\(posterPath)") else {
            return
        }
        DispatchQueue.main.async {
            self.movieImage.kf.setImage(with: imageUrl)
            self.movieTitle.text = "\(String(describing: upcoming.title ?? "")) (\(Helpers.shared.dateFormat(upcoming.release_date, format: "yyyy")))"
            self.movieDescription.text = upcoming.overview
            self.movieDate.text = Helpers.shared.dateFormat(upcoming.release_date, format: "dd.MM.yyyy")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) error occurred")
    }
}
