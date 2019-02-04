//
//  ViewController.swift
//  wordsearch
//
//  Created by River Shelton on 10/7/18.
//  Copyright © 2018 River Shelton. All rights reserved.
//

import UIKit

let puzzletest = puzzle.init(size: nil, name: nil)


class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
       step.wraps = true
        step.minimumValue = 10
        step.maximumValue = 20
    }


    @IBOutlet weak var counter: UILabel!
    
    @IBOutlet weak var step: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
       counter.text = Int(sender.value).description
    
    }
    
    @IBAction func createPuzzle(_ sender: UIButton, forEvent event: UIEvent) {
        if let labelsize = counter.text, let sze = Int(labelsize){
           puzzletest.size = sze
            let randomName = String(arc4random_uniform(1000))
            puzzletest.name = randomName
        }
    
    
}

}
