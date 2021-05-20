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
    var startDate:Date? = nil
    var endDate:Date? = nil
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
    var scoreTime = 0.0
    var btn12:[UIButton] = [UIButton]()
    var btnshuffled:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn12=[btn1,btn2,btn3,
               btn4,btn5,btn6,
               btn7,btn8,btn9]
        
        start()
    }
    @IBAction func Click(_ sender: UIButton) {
        if(i == 0){
            startDate = Date();
        }
        if(sender.currentTitle == btn[i]){
            i+=1
            sender.isEnabled = false
        }else{
            Lbl.text="Wrong"
        }
        if i == 9{
            endDate = Date();
            let playTime = round(endDate!.timeIntervalSince(startDate!)*1000)/1000;
            scoreTime = playTime
            Lbl.text = "Game Clear!!! / time:\(playTime)s"
        }
    }
    @IBAction func Clear(_ sender: UIButton) {
        start()
    }
    func start(){
        i=0
        btnshuffled = btn.shuffled()
        Lbl.text = "Press 1-9"
        for btn in btn12{
            btn.isEnabled = true
            btn.setTitle(btnshuffled.last, for: .normal)
            btnshuffled.removeLast()
        }
    }
    

}

