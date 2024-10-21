//
//  DataModel.swift
//  Pinch
//
//  Created by ISYS Macbook air 1 on 21/10/24.
//

import Foundation

struct Page : Identifiable {
    let id : Int
    let imageName : String
}

extension Page {
    var thumbnailName : String {
        return "thumb-" + imageName
    }
}
