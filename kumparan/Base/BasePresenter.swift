//
//  BasePresenter.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation

protocol PresenterCommonDelegate {}

class BasePresenter<T>: PresenterCommonDelegate {
    var view:T!
    init(view: T!) {
        self.view = view
    }
}
