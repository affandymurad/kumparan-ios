//
//  ViewController.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class postItemCell: UITableViewCell {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postCompany: UILabel!
}

class ViewController: BaseViewController<ViewPresenter>, PostItemDelegates, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    
    var postItemList = Array<PostItem>()
    
    var profileList = Array<Profile>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "All Posts"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        presenter = ViewPresenter(view: self)
        
        presenter.getProfileLits()
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)
    }

    @objc private func refreshInfo(_ sender: Any) {
        postItemList.removeAll()
        tableView.reloadData()
        presenter.getPostItemList()
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
    
    func loadPostItem(postItem: [PostItem]) {
        if !postItem.isEmpty {
            postItemList.append(contentsOf: postItem)
        }
        
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tableView.reloadData()
            
        }
    }
    
    func loadProfileList(profile: [Profile]) {
        if !profile.isEmpty {
            profileList.append(contentsOf: profile)
            presenter.getPostItemList()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postItem", for: indexPath) as! postItemCell
        let postItem = postItemList[indexPath.row]
        
        cell.postTitle.text = postItem.title
        cell.postBody.text = postItem.body
        
        if let profile = profileList.filter({ x in x.id == postItem.userId }).first {
            cell.postUsername.text = "🧑‍💼 \(profile.name)"
            cell.postCompany.text = "🏢 \(profile.company.name)"
        }
        
        cell.postBody.numberOfLines = 0
        cell.postBody.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.postBody.sizeToFit()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let postItem = postItemList[indexPath.row]
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : PostViewController = storyboard.instantiateViewController(withIdentifier: "PostController") as! PostViewController

        if let profile = profileList.filter({ x in x.id == postItem.userId }).first {
            vc.profile = profile
            vc.post = postItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


