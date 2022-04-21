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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    func show(){
        if time != nil{
            print(id)
            print(time!)
            print(scoreTime)
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
    var j=0
    var scoreTime = 0.0
    var btn12:[UIButton] = [UIButton]()
    var btnshuffled:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Realm.Configuration(schemaVersion: 4,
                                         migrationBlock: { migration, oldSchemaVersion in
                                            if oldSchemaVersion < 4 {
                                                migration.enumerateObjects(ofType: ClearTime.className()) { oldObject, newObject in newObject!["id"] = NSUUID().uuidString
                                                }
                                            }
                                         })
        Realm.Configuration.defaultConfiguration = config
        
        btn12=[btn1,btn2,btn3,
               btn4,btn5,btn6,
               btn7,btn8,btn9]
        
        start()
    }
    @IBAction func Click(_ sender: UIButton) {
        
        if(j == 0){
            j+=1
            startDate = Date();
        }
        if(sender.currentTitle == btn[i]){
            i+=1
            sender.isEnabled = false
        }else{
            start()
            Lbl.text="Wrong"
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            let animation = CABasicAnimation(keyPath: "position")
            
            animation.duration = 0.07
            
            animation.repeatCount = 4
            
            animation.autoreverses = true
            for btn in btn12{
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
        }
    }
    @IBAction func Clear(_ sender: UIButton) {
        start()
    }
    @IBAction func Save(_ sender: UIButton) {
        let cleartime:ClearTime = ClearTime()
        
        cleartime.time = String(scoreTime)
        cleartime.scoreTime = scoreTime
        
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
    @IBAction func Search(_ sender: UIButton) {
        let realm = try! Realm()
        print("---loading saved data---")
        
        let fastTimeScoreList:Results<ClearTime> =
            realm.objects(ClearTime.self).filter("scoreTime > 0.0 AND  scoreTime < 5")
        for cleartime in fastTimeScoreList {
            cleartime.show()
        }
    }
    @IBAction func Delete(_ sender: UIButton) {
        let realm = try! Realm()
        
        print("---loading saved data---")
        
        let zeroTimeScoreList:Results<ClearTime> =
            realm.objects(ClearTime.self).filter("scoreTime = 0.0")
        
        try! realm.write {
            realm.delete(zeroTimeScoreList)
        }
        print("---show delete result---")
        
        let cleartimelist:Results<ClearTime> = realm.objects(ClearTime.self)
        
        for cleartime in cleartimelist {
            cleartime.show()
        }
    }
    @IBAction func Update(_ sender: UIButton) {
        let realm = try! Realm()
        
        print("----Update Data ID----")
        
        let query = "id='\(textTargetID.text!)'"
        print("Taken Critea")
        print(query)
        
        let targetScoreList:Results<ClearTime> =
            realm.objects(ClearTime.self).filter(query)
        
        let cleartime:ClearTime = targetScoreList.first!
        
        try! realm.write {
            cleartime.time = Lbl.text
            cleartime.scoreTime = scoreTime
        }
        
        print("----Update----")
        
        let cleartimelist:Results<ClearTime> =
            realm.objects(ClearTime.self)
        
        for cleartime in cleartimelist{
            cleartime.show()
        }
        
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
