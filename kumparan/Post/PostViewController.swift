//
//  PostViewController.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class commentItemCell: UITableViewCell {
    @IBOutlet weak var commentAuthor: UILabel!
    @IBOutlet weak var commentBody: UILabel!
}


class PostViewController: BaseViewController<PostPresenter>, CommentDelegates, UITableViewDelegate, UITableViewDataSource {
    
    var post: PostItem?
    var profile: Profile?
    
    private let refreshControl = UIRefreshControl()
    
    var commentList = Array<Comment>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postCompany: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Post"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        presenter = PostPresenter(view: self)
        
        if let post = self.post, let profile = self.profile {
            postTitle.text = post.title
            postBody.text = post.body
            postUsername.text = "🧑‍💼 \(profile.name)"
            postCompany.text = "🏢 \(profile.company.name)"
            presenter.getCommentItemList(postId: post.id)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(launchProfile))
            postUsername.isUserInteractionEnabled = true
            postUsername.addGestureRecognizer(tap)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)
    }
    
    @objc
        func launchProfile(sender:UITapGestureRecognizer) {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileViewController
            
            if let profile = self.profile {
                vc.profile = profile
                self.navigationController?.pushViewController(vc, animated: true)

            }
        }

    @objc private func refreshInfo(_ sender: Any) {
        commentList.removeAll()
        tableView.reloadData()
        if let post = self.post {
            presenter.getCommentItemList(postId: post.id)
        }
    }
    
    func taskDidBegin() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            var indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView == nil) {
                indicatorView = UIActivityIndicatorView.init(style: .large)
                indicatorView?.tag = 88
            }
            if let bounds = self.navigationController?.view.bounds {
                indicatorView?.frame = bounds
                indicatorView?.backgroundColor = UIColor.init(white: 0, alpha: 0.50)
                indicatorView?.startAnimating()
                indicatorView?.isHidden = false
                self.navigationController?.view.addSubview(indicatorView!)
                self.navigationController?.view.isUserInteractionEnabled = false
            }
        }
    }
    
    
    func taskDidFinish() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            let indicatorView = self.navigationController?.view.viewWithTag(88) as? UIActivityIndicatorView
            if (indicatorView != nil) {
                indicatorView?.stopAnimating()
                indicatorView?.removeFromSuperview()
            }
            self.navigationController?.view.isUserInteractionEnabled = true
        }
    }
    
    func taskDidError(txt: String) {
        taskDidFinish()
        DispatchQueue.main.async {
            self.showAlertAction(title: "Error", message: txt)
        }
    }
    
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadCommentList(comment: [Comment]) {
        if comment.count != 0 {
            commentList.append(contentsOf: comment)
        }
        
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentItem", for: indexPath) as! commentItemCell
        let commentItem = commentList[indexPath.row]
        
        cell.commentAuthor.text = commentItem.name
        cell.commentBody.text = commentItem.body
        
        cell.commentBody.numberOfLines = 0
        cell.commentBody.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.commentBody.sizeToFit()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
