//
//  ViewController.swift
//  TestFirstResponderBug
//
//  Created by Daniel Williams on 6/7/17.
//  Copyright © 2017 Daniel Williams. All rights reserved.
//


import UIKit



class ExpandableCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
}



class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let models = ModelGenerator.generateRandomModels()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    
    
    func updateHeight(for textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expandableCell", for: indexPath) as! ExpandableCell
        let model = models[indexPath.row]

        cell.textView.delegate = self
        cell.textView.text = model.text
        cell.contentView.backgroundColor = model.backgroundColor
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
}



extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        updateHeight(for: textView)
    }
}



// Global helpers
class ModelGenerator {
    
    static private func getRandomString(ofLength length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    
    static private func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    
    typealias Model = (text: String, backgroundColor: UIColor)
    
    static func generateRandomModels() -> [Model] {
        
        var models: [Model] = []
        
        for _ in 1...40 {
            let randomLength = Int(arc4random_uniform(1000))
            let randomString = getRandomString(ofLength: randomLength)
            let randomColor = getRandomColor()
            let model: Model = (text: randomString, backgroundColor: randomColor)
            
            models.append(model)
        }
        
        return models
    }
}
