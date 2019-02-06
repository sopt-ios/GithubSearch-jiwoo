//
//  GithubSearchService.swift
//  GithubSearch
//
//  Created by 김지우 on 2019. 1. 30..
//  Copyright © 2019년 havetherain. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GithubSearchService {
    let baseURL = "https://api.github.com"
    static let shared = GithubSearchService()
    
    func getUserList(keyword: String, token: String, onGetUserList: @escaping([SearchUsersItems]) -> ()) {
        guard var urlComponents = URLComponents(string: baseURL+"/search/users") else { return }
        urlComponents.query = "q=\(keyword)"
        
        guard let URL = urlComponents.url else { return }
        
        let headers = ["Authorization": "token \(token)"]
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { (res) in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let decoder = JSONDecoder()
                    do {
                        let searchUsersResult = try decoder.decode(SearchUsers.self, from: value)
                        onGetUserList(searchUsersResult.items)
                    } catch let err as NSError {
                        print(err.localizedDescription)
                    }
                }
                break
            case .failure(let err) :
                print(err.localizedDescription)
                break
            }
        }
    }
    
    func getUserInfo(username: String, token: String, onGetUserInfo: @escaping(Int) -> ()) {
        let headers = ["Authorization": "token \(token)"]
        let URL = self.baseURL + "/users/\(username)"
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseData { (res) in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let data = JSON(value)
                    onGetUserInfo(data["public_repos"].intValue)
                }
                break
            case .failure(let err) :
                print(err.localizedDescription)
                break
            }
        }
    }
}

