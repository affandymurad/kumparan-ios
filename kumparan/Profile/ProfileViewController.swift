//
//  ProfileViewController.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class albumItemCell: UITableViewCell {
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        albumCollectionView.delegate = dataSourceDelegate
        albumCollectionView.dataSource = dataSourceDelegate
        albumCollectionView.tag = row
        albumCollectionView.reloadData()
    }
}

class albumPhotoItemCell: UICollectionViewCell {
    @IBOutlet weak var albumPhotoImageView: UIImageView!
}

class ProfileViewController: BaseViewController<ProfilePresenter>, AlbumDelegates, UITableViewDelegate, UITableViewDataSource {

    var profile: Profile?
    
    private let refreshControl = UIRefreshControl()
    
    var albumList = Array<Album>()
    var photoList = Array<Photo>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    @IBOutlet weak var profileCompany: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        
        presenter = ProfilePresenter(view: self)
        
        if let profile = self.profile {
            profileName.text = "🧑‍💼 \(profile.name)"
            profileEmail.text = "📧 \(profile.email)"
            profileAddress.text = "🏠 \(profile.address.street), \(profile.address.suite), \(profile.address.city)"
            profileCompany.text = "🏢 \(profile.company.name)"
            presenter.getAllPhotoList()
        }
        
        refreshControl.addTarget(self, action: #selector(refreshInfo(_:)), for: .valueChanged)
    }

    
    @objc private func refreshInfo(_ sender: Any) {
        albumList.removeAll()
        tableView.reloadData()
        if let profile = self.profile {
            presenter.getAlbumList(userId: profile.id)
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
    
    func loadPhotoList(photo: [Photo]) {
        if photo.count != 0 {
            photoList.append(contentsOf: photo)
        }
        
        DispatchQueue.main.async {
            self.taskDidFinish()
            if let profile = self.profile {
                self.presenter.getAlbumList(userId: profile.id)
            }
        }
    }
    
    func loadAlbumList(album: [Album]) {
        if album.count != 0 {
            albumList.append(contentsOf: album)
        }
        
        DispatchQueue.main.async {
            self.taskDidFinish()
            self.tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumItem", for: indexPath) as! albumItemCell
        let albumItem = albumList[indexPath.row]
        
        cell.albumTitle.text = albumItem.title
        cell.albumTitle.numberOfLines = 0
        cell.albumTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.albumTitle.sizeToFit()
        cell.selectionStyle = .none
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.filter({ x in x.albumId == self.albumList[collectionView.tag].id }).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumPhotoItem",
                                                      for: indexPath) as! albumPhotoItemCell
        let photo = photoList.filter({ x in x.albumId == self.albumList[collectionView.tag].id })[collectionView.tag]
        cell.albumPhotoImageView.downloaded(from: photo.thumbnailUrl)
        let tap = PhotoTapGesture(target: self, action: #selector(launchPhoto))
        tap.photo = photo
        cell.albumPhotoImageView.isUserInteractionEnabled = true
        cell.albumPhotoImageView.addGestureRecognizer(tap)
        cell.albumPhotoImageView.layer.cornerRadius = 8
        return cell
    }
    

    
    @objc func launchPhoto(_ sender: PhotoTapGesture) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : PhotoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoController") as! PhotoViewController
        vc.photo = sender.photo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class PhotoTapGesture: UITapGestureRecognizer {
    var photo: Photo?
}
