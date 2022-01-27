//
//  BaseDelegate.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

protocol BaseDelegate {
    func taskDidBegin()
    func taskDidFinish()
    func taskDidError(txt: String)
}

extension BaseDelegate {
    func taskDidBegin() {}
    func taskDidFinish() {}
    func taskDidError(txt: String) {}
}
