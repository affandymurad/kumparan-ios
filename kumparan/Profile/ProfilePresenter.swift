//
//  ProfilePresenter.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation
import UIKit

class ProfilePresenter: BasePresenter<AlbumDelegates> {
    var albumList: [Album] = []
    var photoList: [Photo] = []
    
    func getAlbumList(userId: Int){
        self.view.taskDidBegin()
        if !albumList.isEmpty { albumList.removeAll() }
        let endpoint = URL(string: "https://jsonplaceholder.typicode.com/albums?userId=\(userId)")
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
                let aList = try JSONDecoder().decode([Album].self, from: data)
                self.albumList.append(contentsOf: aList)
                self.view.loadAlbumList(album: aList)
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
    
    func getAllPhotoList(){
        self.view.taskDidBegin()
        if !photoList.isEmpty { photoList.removeAll() }
        let endpoint = URL(string: "https://jsonplaceholder.typicode.com/photos")
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
                let photoList = try JSONDecoder().decode([Photo].self, from: data)
                self.photoList.append(contentsOf: photoList)
                self.view.loadPhotoList(photo: photoList)
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

protocol AlbumDelegates: BaseDelegate {
    func loadAlbumList(album: [Album])
    func loadPhotoList(photo: [Photo])
}
