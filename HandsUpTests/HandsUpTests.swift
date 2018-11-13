//
//  HandsUpTests.swift
//  HandsUpTests
//
//  Created by Claudia Nelson on 10/14/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import XCTest
//@testable import HandsUp
import Parse

class HandsUpTests: XCTestCase {

    func testExample() {
        let query = PFQuery(className: "Post")
        
        let postID = "Sif2uqA8HR"
//        query.includeKey("_id")
        query.whereKey("id", equalTo: postID)
        query.findObjectsInBackground { (raised_posts: [PFObject]?, error: Error?) in
            print(raised_posts as Any)
        }
    }
}
