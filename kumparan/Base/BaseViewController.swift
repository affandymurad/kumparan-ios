//
//  BaseViewController.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import UIKit

class BaseViewController<T: PresenterCommonDelegate>: UIViewController {
    var presenter: T!
}
