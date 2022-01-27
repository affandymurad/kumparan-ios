//
//  Model.swift
//  kumparan
//
//  Created by Affandy Murad on 26/01/22.
//

import Foundation

struct Errors: Codable {
    var status_code: Int
    var status_message: String
    var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case success = "success"
    }
}

// Model PostItem
struct PostItem: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}

// Model Profile
struct Profile: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case email
        case address
        case phone
        case website
        case company
    }
}

struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
    
    enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipcode
        case geo
    }
}

struct Geo: Codable {
    var lat: String
    var lng: String
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}


struct Company: Codable {
    var name: String
    var catchPhrase: String
    var bs: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case catchPhrase
        case bs
    }
}

// Model Comment
struct Comment: Codable {
    var id: Int
    var name: String
    var postId: Int
    var email: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case postId
        case email
        case body
    }
}

// Model Album
struct Album: Codable {
    var id: Int
    var userId: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
    }
}

// Model Photo
struct Photo: Codable {
    var id: Int
    var albumId: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumId
        case title
        case url
        case thumbnailUrl
    }
}
