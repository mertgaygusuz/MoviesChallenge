//
//  HomeViewController.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private var homeViewModel = HomeViewModel()
    private var popular = [PopularResults]()
    var timer : Timer?
    var currentIndex = 0
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 19)
        return table
    }()
    
    var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    private var headerView: UIView = {
        let view = UIView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        fetch(pullRefresh: false)
        tableViewConfigure()
        collectionViewConfigure()
        startTimer()
    }
    
    private func viewConfigure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.addSubview(headerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 256)
    }

    private func fetch(pullRefresh: Bool) {
        homeViewModel.getUpcomingMovies(tableView, pullRefresh: pullRefresh)
        homeViewModel.getPopularMovies(collectionView, pageControl: pageControl, pullRefresh: pullRefresh)
    }
    
    private func tableViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.tableHeaderView = headerView
        headerView.addSubview(collectionView)
        headerView.addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(256)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(headerView.snp.bottom).offset(-16)
            make.centerX.equalTo(headerView.snp.centerX)
        }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(movieIndex), userInfo: nil, repeats: true)
    }
        
    @objc func movieIndex() {
        if currentIndex == popular.count-1 {
            currentIndex = -1
        } else {
            currentIndex += 1
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            pageControl.currentPage = currentIndex
        }
    }
    
    @objc private func didPullToRefresh() {
        homeViewModel.fetchRefresh()
        fetch(pullRefresh: true)
    }
    
    private func collectionViewConfigure() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        cell.set(homeViewModel.collectionViewCell(with: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let detailView = HomeDetailViewController()
        detailView.movieId = homeViewModel.getPopularId(with: indexPath)
        Helpers.shared.presentViewController(self, detailView: detailView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
        homeViewModel.paginationPopular(collectionView, indexPath: indexPath, pageControl: pageControl)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        cell.set(homeViewModel.tableViewCell(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailView = HomeDetailViewController()
        detailView.movieId = homeViewModel.getUpcomingId(with: indexPath)
        Helpers.shared.presentViewController(self, detailView: detailView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        homeViewModel.paginationUpComing(tableView,indexPath: indexPath)
    }
}

