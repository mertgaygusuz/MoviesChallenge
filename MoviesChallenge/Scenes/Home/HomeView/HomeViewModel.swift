//
//  HomeViewModel.swift
//  MoviesChallenge
//
//  Created by Mert Gaygusuz on 11.11.2022.
//

import Foundation
import UIKit

final class HomeViewModel {
    
    private var popular = [PopularResults]()
    private var upcoming = [UpcomingResults]()
    private var upcomingPage = 1
    private var popularPage = 1
    
    public func getPopularMovies(_ collectionView: UICollectionView, pageControl: UIPageControl, pullRefresh: Bool){
        Webservice.shared.getPopularMovies(page: popularPage) { response in
            switch response {
                case .success(let popular):
                    DispatchQueue.main.async {
                        if pullRefresh {
                            self.popular.removeAll()
                        }
                        self.popular.append(contentsOf: popular.results ?? [])
                        pageControl.numberOfPages = self.popular.count
                        collectionView.reloadData()
                    }
                case .failure(_):
                    break;
            }
        }
    }
    
    public func getUpcomingMovies(_ tableView: UITableView, pullRefresh: Bool){
        Webservice.shared.getUpcomingMovies(page: upcomingPage) { response in
            switch response {
                case .success(let upcoming):
                    DispatchQueue.main.async {
                        if pullRefresh {
                            self.upcoming.removeAll()
                        }
                        self.upcoming.append(contentsOf: upcoming.results ?? [])
                        tableView.reloadData()
                        tableView.refreshControl?.endRefreshing()
                    }
                    
                case .failure(_):
                    break;
            }
        }
    }
    
    public func numberOfItemsInSection() -> Int {
        return popular.count
    }
    
    public func numberOfRowsInSection() -> Int {
        return upcoming.count
    }
    
    public func tableViewCell(indexPath: IndexPath) -> UpcomingResults{
        return upcoming[indexPath.row]
    }
    
    public func collectionViewCell(with indexPath: IndexPath) -> PopularResults{
        return popular[indexPath.row]
    }
    
    public func getPopularId(with indexPath: IndexPath) -> Int {
        return popular[indexPath.row].id ?? 0
    }
    
    public func getUpcomingId(with indexPath: IndexPath) -> Int {
        return upcoming[indexPath.row].id ?? 0
    }
    
    public func increaseUpcomingPage() {
        self.upcomingPage += 1
    }
    
    public func increasePopularPage() {
        self.popularPage += 1
    }
    
    public func paginationPopular(_ collectionView: UICollectionView,indexPath: IndexPath, pageControl: UIPageControl) {
        if indexPath.row == popular.count - 1 {
            increasePopularPage()
            getPopularMovies(collectionView, pageControl: pageControl, pullRefresh: false)
        }
    }
    
    public func paginationUpComing(_ tableView: UITableView,indexPath: IndexPath) {
        if indexPath.row == upcoming.count - 1 {
            increaseUpcomingPage()
            getUpcomingMovies(tableView, pullRefresh: false)
        }
    }
    
    public func currentPage(pageControl: UIPageControl, indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    public func fetchRefresh(){
        popularPage = 1
        upcomingPage = 1
    }
}
