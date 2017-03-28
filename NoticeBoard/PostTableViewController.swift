//
//  ViewController.swift
//  NoticeBoard
//
//  Created by Ethan Hu on 25/03/2017.
//  Copyright © 2017 Ethan Hu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostTableViewController: UITableViewController {
    
    var posts = [[Post]]()

    private func showAlert(withMessage message : String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshPosts(_ sender: UIRefreshControl) {
        posts.removeAll()
        self.tableView.reloadData()
        getPosts()
    }
    
    
    private func insertPost(){
        self.tableView.insertSections([posts.count - 1], with: .fade)
    }
    
    private func getPosts() {
        let postContentCharacterLimit = 80
        let getPostAPIAdress = "https://hfi.me/api/post/for"
        let pageNumber:Int = posts.count + 1
        Alamofire.request(getPostAPIAdress, method: .get, parameters: ["page":"\(pageNumber)"]).responseJSON { [weak self] response in
            var newPosts = [Post]()
            switch response.result {
            case .success(let value):
                let postResponseJson = JSON(value)
                let postData = postResponseJson["data"]
                for (_, post):(String, JSON) in postData {
                    let postId = "\(post["id"].int!)"
                    let postTitle = post["title"].string!
                    var postContent = post["content"].string!.replacingOccurrences(of: "\n", with: " ")
                    postContent = postContent.substring(to: postContent.index(postContent.startIndex, offsetBy: (postContent.characters.count >= postContentCharacterLimit) ? postContentCharacterLimit : postContent.characters.count)) + "..."
                    let postCreatedDate = post["created_at"].string!
                    let userAvatarLink = post["get_author"]["avatar"].string!
                    let userName = post["get_author"]["name"].string!
                    newPosts.append(Post(id:postId, title: postTitle, content: postContent, createdDate: postCreatedDate, author: userName, avatar: userAvatarLink))
                }
            case .failure(let error):
                print(error)
                self?.showAlert(withMessage: "Internet Connection Problem")
            }
            self?.posts.append(newPosts)
            self?.insertPost()
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        getPosts()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.post = posts[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == posts.count - 1 && indexPath.row == posts[posts.count - 1].count - 1 {
            getPosts()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sourcePostTableViewCell = sender as? PostTableViewCell {
            if let destinationIndividualPostViewController = segue.destination as? IndividualPostViewController {
                destinationIndividualPostViewController.postId = sourcePostTableViewCell.id
            }
        }
    }

}

