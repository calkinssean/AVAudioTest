//
//  AudioFile.swift
//  Integrated-Algorithm
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import Foundation

class AudioFile {
    
    var title: String = ""
    var filePath = NSURL()
    
    init(title: String, filePath: NSURL) {
        self.title = title
        self.filePath = filePath
    }
    
}
