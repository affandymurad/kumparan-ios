//
//  kumparanTests.swift
//  kumparanTests
//
//  Created by Affandy Murad on 26/01/22.
//

import XCTest
@testable import kumparan

class kumparanTests: XCTestCase {

    let viewPresenter = ViewPresenter(view: ViewController())
    let postPresenter = PostPresenter(view: PostViewController())
    let profilePresenter = ProfilePresenter(view: ProfileViewController())

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            viewPresenter.getPostItemList()
            viewPresenter.getProfileLits()
            postPresenter.getCommentItemList(postId: 1)
            profilePresenter.getAlbumList(userId: 1)
            profilePresenter.getAllPhotoList()
        }
    }

}
