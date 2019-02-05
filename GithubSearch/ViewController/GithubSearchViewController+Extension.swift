//
//  GithubSearchViewController+Extension.swift
//  GithubSearch
//
//  Created by 김지우 on 2019. 1. 30..
//  Copyright © 2019년 havetherain. All rights reserved.
//

import UIKit

extension GithubSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.noDataLabel.isHidden = false
            self.searchUsersItems.removeAll()
            self.displaySearchUsersItems.removeAll()
            self.usersNamesArray.removeAll()
            self.usersPublicRepoCntArray.removeAll()
            self.perform(#selector(self.loadTable), with: nil, afterDelay: 1.0)
        } else {
            self.noDataLabel.isHidden = true
            if self.searchUsersItems.count != 0 {
                self.searchUsersItems.removeAll()
                self.displaySearchUsersItems.removeAll()
                self.usersNamesArray.removeAll()
                self.usersPublicRepoCntArray.removeAll()
            }
            GithubSearchService.shared.getUserList(keyword: searchText, token: self.token) { (res) in
                self.searchUsersItems = res
                self.totalEntries = self.searchUsersItems.count
                self.appenddisplaySearchUsersItems(startIndex: 0)
            }
        }
    }
}

extension GithubSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displaySearchUsersItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GithubSearchTableViewCell", for: indexPath) as! GithubSearchTableViewCell
        cell.profileImageView.imageFromUrl(self.displaySearchUsersItems[indexPath.row].avatar_url, defaultImgPath: "defaultProfile")
        cell.nameLabel.text = self.displaySearchUsersItems[indexPath.row].login
        cell.publicReposCountLabel.text = "\(self.usersPublicRepoCntArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.displaySearchUsersItems.count - 1) {
            if self.displaySearchUsersItems.count < self.totalEntries {
                let startIndex = displaySearchUsersItems.count
                self.limit = startIndex + 20
            
                self.appenddisplaySearchUsersItems(startIndex: startIndex)
            }
        }
    }
}

