//
//  Puzzle.swift
//  wordsearch
//
//  Created by River Shelton on 10/7/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import Foundation

class puzzle{
    var puzz: [[String]]? = []
    var size: Int?
    var name: String?
    
    init(puzz: [[String]]? = nil, key: [[String]]? = nil, size: Int?, name: String?){
        self.puzz = puzz
        self.size = size
        self.name = name
    }
    
    func setPuzzline(array ar: [String], linelocation lnlo: Int){
        puzz?.append(ar)
    }
    func getPuzzleline() -> [String]?{
        let line = puzz?.removeFirst()
        return line
    }

    
}
