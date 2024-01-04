//
//  ViewController.swift
//  Hangman@
//
//  Created by suhail on 24/07/23.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnLetter: [UIButton]!
    @IBOutlet var lblSCore: UILabel!
    @IBOutlet var lblRemaining: UILabel!
    @IBOutlet var lblAnswer: UILabel!
    @IBOutlet var lblGuuess: UILabel!
    
    var score = 0{
        didSet{
            lblSCore.text = "Score: \(score)"
        }
    }
    var remaining = 0{
        didSet{
            lblRemaining.text = " Chances Remaining: \(remaining)"
        }
      
    }
    var maxScore = 0
    var allWordArray = [String]()
    var currentWordd = String()
    var currentWordArray = [String]()
    var promptWord = [String]()
    var letterButtons = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for btn in btnLetter{
            
                btn.layer.cornerRadius = 12
                btn.layer.borderColor = UIColor.black.cgColor
                btn.layer.borderWidth = 1
                btn.layer.backgroundColor = UIColor.systemTeal.cgColor
                btn.tintColor = UIColor.black
               btn.titleLabel?.font = UIFont(name: "Times New Roman", size: 17)
           
        }
        loadLevel()
    }

    func loadLevel(){
        if let hangFile = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let allWordString = try? String(contentsOf: hangFile){
                 allWordArray = allWordString.components(separatedBy: "\n")
                }
            }
        
        if let currentWord = allWordArray.randomElement(){
            print(currentWord)
            currentWordd = currentWord.uppercased()
            print(currentWordd)
            for letter in currentWordd{
                currentWordArray.append(String(letter))
                promptWord.append("_  ")
               
            }
            print(promptWord.joined())
            
            lblTitle.text = String(currentWordd.shuffled())
            remaining = currentWordd.count
            maxScore = currentWord.count
            lblRemaining.text = " Chances Remaining: \(remaining)"
            lblSCore.text = "SCore: \(score)"
            lblGuuess.text = "It is an \(maxScore) letter word."
            lblAnswer.text = promptWord.joined()
        }
        
    }
    
    @IBAction func letterTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.layer.backgroundColor = UIColor.lightGray.cgColor
        print(sender.configuration?.title!)
        letterButtons.append(sender)
        
        if let enteredLetter = sender.configuration?.title!{
            print(enteredLetter)
            if currentWordd.contains(enteredLetter){
            for (index,letter) in currentWordArray.enumerated(){
                   
                    if letter == enteredLetter{
                        score += 1
                        promptWord[index] = " \(letter)"
                    }
                }
                DispatchQueue.main.async{ [self] in
                    self.lblAnswer.text = " \(promptWord.joined())"

                }
                if score == maxScore{
                    let ac = UIAlertController(title: "Well Done!", message: "You have sucessfully guessed the word", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "New Word", style: .default,handler: newWord))
                    present(ac,animated: true)
                }
            }
            
            else{
                remaining -= 1
                if remaining == 0{
                    let ac = UIAlertController(title: "Game Over!", message: "You used up all your guesses", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "New Word", style: .default,handler: newWord))
                    present(ac,animated: true)
                }
              
            }
        }
    
    }
    func newWord(action: UIAlertAction){
        for btn in letterButtons{
            btn.isEnabled = true
            btn.layer.backgroundColor = UIColor.systemTeal.cgColor
        }
        score = 0
        remaining = 0
        currentWordd =  ""
        currentWordArray.removeAll()
        letterButtons.removeAll()
        promptWord.removeAll()
        loadLevel()
    }
}

