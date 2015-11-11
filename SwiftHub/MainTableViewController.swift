//
//  MainTableViewController.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

protocol RepoViewDelegate {
    func refreshReposWithNewFilters(filters: [RepositoriesFilter]?)
}

class MainTableViewController: UITableViewController, RepoViewDelegate {

    var repos: [Repository] = []
    var usingFilters: [RepositoriesFilter] = []
    var pagesDownloaded = 0
    
    let filterViewController = MainFiltersTableViewController(style: .Grouped)
    
    
    
    
    
    
    
    override func viewDidLoad() {
        title = "Repos"
        tableView.registerClass(RepoPreviewTableViewCell.self, forCellReuseIdentifier: "repoCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: "openFilters")
        let searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "openSearch")
        let savedButton = UIBarButtonItem(image: UIImage(named: "Save"), style: .Plain, target: self, action: "openSaved")
        navigationItem.rightBarButtonItems = [searchButton, savedButton]
        
        filterViewController.delegate = self
        usingFilters = GHAPIManager.defaultQualifiers()
    }
    
    func openFilters() {
        if !usingFilters.isEmpty {
            filterViewController.selectRowForFilters(usingFilters)
        }
        
        presentViewController(UINavigationController(rootViewController: filterViewController), animated: true, completion: nil)
    }
    
    func openSearch() {
        let nav = UINavigationController(rootViewController: SearchTableViewController())
        nav.modalTransitionStyle = .CrossDissolve
        nav.modalPresentationStyle = .OverCurrentContext
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func openSaved() {
        let nav = UINavigationController(rootViewController: SavedReposTableViewController())
        nav.modalTransitionStyle = .CrossDissolve
        nav.modalPresentationStyle = .OverCurrentContext
        presentViewController(nav, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if repos.isEmpty {
           fetchData()
        }
    }
    
    func fetchData() {
        pagesDownloaded += 1
        GHAPIManager.downloadRepositories(self, atPage: pagesDownloaded, withFilters: usingFilters)
    }
    
    
    
    
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepoPreviewTableViewCell

        let repo = repos[indexPath.row]
        return cell.setCell(repo)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        let vc = RepoSafariViewController(URL: repo.url)
        vc.repo = repo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == repos.count - 1 && repos.count > (20 * pagesDownloaded) {
            fetchData()
        }
    }

    
    
    
    
    
    
    
    func insertNewRepo(repo: Repository) {
        tableView.beginUpdates()
        repos.append(repo)
        let indexPath = NSIndexPath(forRow: repos.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    func refreshReposWithNewFilters(filters: [RepositoriesFilter]?) {
        if let filters = filters {
            if filters != usingFilters {
                self.usingFilters = filters
                
                tableView.beginUpdates()
                repos.removeAll()
                var indexPathsToRemove: [NSIndexPath] = []
                for index in 0...tableView.numberOfRowsInSection(0) - 1 {
                    indexPathsToRemove.append(NSIndexPath(forRow: index, inSection: 0))
                }
                tableView.deleteRowsAtIndexPaths(indexPathsToRemove, withRowAnimation: .Automatic)
                tableView.endUpdates()
                
                
                pagesDownloaded = 0
                fetchData()
            }
        }
    }

    

}
