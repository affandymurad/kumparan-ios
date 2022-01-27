//
//  PostPresenter.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class PostPresenter: BasePresenter<CommentDelegates> {
    var commentList: [Comment] = []
    
    func getCommentItemList(postId: Int){
        self.view.taskDidBegin()
        if !commentList.isEmpty { commentList.removeAll() }
        let endpoint = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")
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
                let cList = try JSONDecoder().decode([Comment].self, from: data)
                self.commentList.append(contentsOf: cList)
                self.view.loadCommentList(comment: self.commentList)
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


protocol CommentDelegates: BaseDelegate {
    func loadCommentList(comment: [Comment])
}
