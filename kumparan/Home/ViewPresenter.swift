//
//  ViewPresenter.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class ViewPresenter: BasePresenter<PostItemDelegates> {
    var postItemList: [PostItem] = []
    var profileList: [Profile] = []
    
    func getPostItemList() {
        self.view.taskDidBegin()
        if !postItemList.isEmpty { postItemList.removeAll() }
        let endpoint = URL(string: "https://jsonplaceholder.typicode.com/posts")
        guard let url =  endpoint else { return }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) in
            guard let data = data else {
                self.view.taskDidError(txt: "Unknown")
                return
            }
            
            do{
                let piList = try JSONDecoder().decode([PostItem].self, from: data)
                self.postItemList.append(contentsOf: piList)
                self.view.loadPostItem(postItem: piList)
            } catch {
                do{
                    let errors = try JSONDecoder().decode(Errors.self, from: data)
                    self.view.taskDidError(txt: errors.status_message)
                } catch DecodingError.keyNotFound(let key, let context) {
                      self.view.taskDidError(txt: "could not find key \(key) in JSON: \(context.debugDescription)")
                  } catch DecodingError.valueNotFound(let type, let context) {
                      self.view.taskDidError(txt: "could not find type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.typeMismatch(let type, let context) {
                      self.view.taskDidError(txt: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.dataCorrupted(let context) {
                      self.view.taskDidError(txt: "data found to be corrupted in JSON: \(context.debugDescription)")
                  } catch let error as NSError {
                      self.view.taskDidError(txt: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                  }
            }
        })
        task.resume()
    }
    
    func getProfileLits() {
        self.view.taskDidBegin()
        if !profileList.isEmpty { profileList.removeAll() }
        let endpoint = URL(string: "https://jsonplaceholder.typicode.com/users")
        guard let url =  endpoint else { return }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) in
            guard let data = data else {
                self.view.taskDidError(txt: "Unknown")
                return
            }
            
            do{
                let profileItem = try JSONDecoder().decode([Profile].self, from: data)
                self.profileList.append(contentsOf: profileItem)
                self.view.loadProfileList(profile: profileItem)
            } catch {
                do{
                    let errors = try JSONDecoder().decode(Errors.self, from: data)
                    self.view.taskDidError(txt: errors.status_message)
                } catch DecodingError.keyNotFound(let key, let context) {
                      self.view.taskDidError(txt: "could not find key \(key) in JSON: \(context.debugDescription)")
                  } catch DecodingError.valueNotFound(let type, let context) {
                      self.view.taskDidError(txt: "could not find type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.typeMismatch(let type, let context) {
                      self.view.taskDidError(txt: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.dataCorrupted(let context) {
                      self.view.taskDidError(txt: "data found to be corrupted in JSON: \(context.debugDescription)")
                  } catch let error as NSError {
                      self.view.taskDidError(txt: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                  }
            }
        })
        task.resume()
    }
}

protocol PostItemDelegates: BaseDelegate {
    func loadPostItem(postItem: [PostItem])
    func loadProfileList(profile: [Profile])
}
