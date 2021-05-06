//
//  ViewController.swift
//  ClickGame
//
//  Created by WENDRA RIANTO on 2021/04/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Lbl: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    let btn=["1",
             "2",
             "3",
             "4",
             "5",
             "6",
             "7",
             "8",
             "9"]
    var i=0
    var btn12:[UIButton] = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        btn12=[btn1,btn2,btn3,
               btn4,btn5,btn6,
               btn7,btn8,btn9]
    }
    @IBAction func Click(_ sender: UIButton) {
        if(sender.currentTitle == btn[i]){
            i+=1
            sender.isEnabled = false
        }else{
            Lbl.text="Wrong"
        }
        if(i > 8){
            Lbl.text = "Game Clear"
            i=0
        }
    }
    @IBAction func Clear(_ sender: UIButton) {
        i=0
        Lbl.text = "Press 1-9"
        for btn in btn12{
            btn.isEnabled = true
        }
    }
    

}

