//
//  PhotoViewController.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "Photo"
        
        photoImageView.isUserInteractionEnabled = true
        photoImageView.enableZoom()
        
        if let photo = self.photo {
            photoImageView.downloaded(from: photo.thumbnailUrl)
            photoTitle.text = photo.title
        }
    }
}
