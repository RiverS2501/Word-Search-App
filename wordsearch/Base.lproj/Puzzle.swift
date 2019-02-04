//
//  Puzzle.swift
//  wordsearch
//
//  Created by River Shelton on 10/7/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import Foundation

class puzzle{
    var puzz: [Character]?
    var size: Int?
    var name: String?
    
    init(puzz: [Character]?, size: Int?, name: String?){
        self.puzz = puzz
        self.size = size
        self.name = name
    }
    
    func setPuzzline(ar: [Character]){
        puzz = ar
    }
    
}
