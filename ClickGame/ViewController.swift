//
//  ViewController.swift
//  ClickGame
//
//  Created by WENDRA RIANTO on 2021/04/22.
//

import UIKit
import RealmSwift

class ClearTime: Object{
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var time:String? = nil
    @objc dynamic var scoreTime:Double = 0.0
    @objc dynamic var Level:Int = 1
    
    override static func primaryKey() -> String? {
        return "id"
    }
    func show(){
        if time != nil{
            print(id)
            print(time!)
            print(scoreTime)
            print(Level)
            print()
        }
        else{
            print("data not saved properly")
        }
    }}
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
    @IBOutlet weak var textTargetID: UITextField!
    @IBOutlet weak var levelControlSegment: UISegmentedControl!
    var startDate:Date? = nil
    var endDate:Date? = nil
    var btnNumber=["1",
             "2",
             "3",
             "4",
             "5",
             "6",
             "7",
             "8",
             "9"]
    var i=0
    var j=0
    var scoreTime = 0.0
    var btnList:[UIButton] = [UIButton]()
    var btnNumbershuffled:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Realm.Configuration(schemaVersion: 5,
                                         migrationBlock: { migration, oldSchemaVersion in
                                            if oldSchemaVersion < 4 {
                                                migration.enumerateObjects(ofType: ClearTime.className()) { oldObject, newObject in newObject!["id"] = NSUUID().uuidString
                                                }
                                            }
                                            if oldSchemaVersion < 5{
                                                migration.enumerateObjects(ofType: ClearTime.className()) { oldObject, newObject in newObject!["Level"] = 1
                                                }
                                            }
                                         })
        Realm.Configuration.defaultConfiguration = config
        
        btnList=[btn1,btn2,btn3,
               btn4,btn5,btn6,
               btn7,btn8,btn9]
        
        start()
    }
    @IBAction func SegmentChange(_ sender: UISegmentedControl) {
        start()
    }
    @IBAction func Click(_ sender: UIButton) {
        
        if(j == 0){
            j+=1
            startDate = Date();
        }
        if(sender.currentTitle == btnNumber[i]){
            i+=1
            sender.isEnabled = false
        }else{
            start()
            Lbl.text="Wrong "+Lbl.text!
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            let animation = CABasicAnimation(keyPath: "position")
            
            animation.duration = 0.07
            
            animation.repeatCount = 4
            
            animation.autoreverses = true
            for btn in btnList{
                animation.fromValue = NSValue(cgPoint: CGPoint(x:btn.center.x - 10, y: btn.center.y))
                
                animation.toValue = NSValue(cgPoint: CGPoint(x:btn.center.x + 10, y: btn.center.y))
                
                btn.layer.add(animation,forKey:"position")
            }
            
        }
        if i == 9{
            endDate = Date();
            let playTime = round(endDate!.timeIntervalSince(startDate!)*1000)/1000;
            scoreTime = playTime
            Lbl.text = "Game Clear!!! / time:\(playTime)s"
            j=0
            Save()
        }
    }
    @IBAction func Clear(_ sender: UIButton) {
        start()
    }
    func Save(){
        let cleartime:ClearTime = ClearTime()
        
        cleartime.time = String(scoreTime)
        cleartime.scoreTime = scoreTime
        cleartime.Level = levelControlSegment.selectedSegmentIndex + 1
        let realm = try! Realm()
        
        print("---Saving---")
        
        try! realm.write{
            realm.add(cleartime)
        }
        
        let cleartimelist:Results<ClearTime> =
            realm.objects(ClearTime.self)
        
        print("---loading saved data---")
        for cleartime in cleartimelist{
            cleartime.show()
        }
    }
    func start(){
        i=0
        btnNumbershuffled = btnNumber.shuffled()
        btnNumber=["1",
                 "2",
                 "3",
                 "4",
                 "5",
                 "6",
                 "7",
                 "8",
                 "9"]
        if(levelControlSegment.selectedSegmentIndex == 0){
            Lbl.text = "Press 1-9"
            for btn in btnList{
                btn.isEnabled = true
                btn.setTitle(btnNumbershuffled.last, for: .normal)
                btnNumbershuffled.removeLast()
            }
        }
        if(levelControlSegment.selectedSegmentIndex == 1){
            Lbl.text = "Press "
            btnNumber = btnNumbershuffled
            for num in btnNumbershuffled{
                if(num == btnNumbershuffled[0]){
                    Lbl.text = Lbl.text!+num
                }else{
                    Lbl.text = Lbl.text!+","+num
                }
            }
            for btn in btnList{
                btn.isEnabled = true
                btn.setTitle(btnNumbershuffled.last, for: .normal)
                btnNumbershuffled.removeLast()
            }
//            while(i != 9){
//                btnshuffled = btn.shuffled()
//                for btns in btn12{
//                    let random = Int.random(in: 1...9)
//                    if(btns.currentTitle == String(random)){
//                        UIView.animate(withDuration: 0.5, animations: {
//                            btns.alpha = 0
//                        })
//                        UIView.animate(withDuration: 0.5, animations: {
//                            btns.alpha = 1
//                        })
//                    }
//                }
//            }
//            btn
            
        }
    }
    

}
