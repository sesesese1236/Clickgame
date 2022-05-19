//
//  RankingViewController.swift
//  ClickGame
//
//  Created by WENDRA RIANTO on 2022/05/12.
//

import UIKit
import RealmSwift

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(now == 0){
            count = levelDistinctList.count
            btnDelete.isEnabled = false
        }else{
            count = rankingList!.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell =
        tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(now == 0){
            cell.textLabel?.text = "Level \(levelDistinctList[indexPath.row])"
        }else{
            cell.textLabel?.text = "\(indexPath.row+1).Time: \(rankingList![indexPath.row].scoreTime)"
        }
        return cell
    }
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        if(now == 0){
            selectedLevel = Int(levelDistinctList[indexPath.row])!
            
            now = 1
            
            let realm = try! Realm()
            rankingList = realm.objects(ClearTime.self).filter("Level = \(selectedLevel)")
            rankingList = rankingList!.sorted(byKeyPath: "scoreTime")
            
            tableView.reloadData()
        }
        else if(now == 1){
//            Name = nameList![indexPath.row].Name
//            Id = nameList![indexPath.row].id
//            indexS = indexPath.row
            btnDelete.isEnabled = true
            index = indexPath.row
            func rowDelete(){
                rankingView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                
                rankingView.reloadData()
            }
            idLabel.text = "id:"+rankingList![indexPath.row].id
        }
    }
    var rankingList:Results<ClearTime>?=nil
    @IBOutlet weak var rankingView: UITableView!
    var levelDistinctList = [String]()
    var now = 0
    var selectedLevel = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingView.delegate = self
        rankingView.dataSource = self
        let realm = try! Realm()
        rankingList = realm.objects(ClearTime.self)
        let tempList:[Int] = (realm.objects(ClearTime.self).value(forKey:"Level") as! [Int])
        var levelList:[String] = []
        for temp in tempList{
            levelList.append(String(temp))
        }
        let distinctLevel = Set(levelList)
        levelDistinctList = Array(distinctLevel)
        levelDistinctList.sort()
        btnDelete.isEnabled = false
    }
    @IBAction func Back(_ sender: UIButton) {
        if(now == 1){
            now = 0
            
            rankingView.reloadData()
            btnDelete.isEnabled = false
        }else if(now == 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
            self.present(viewController, animated:true, completion:nil)
        }
    }
    @IBAction func Delete(_ sender: UIButton) {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(rankingList![index])
        }
        rankingView.reloadData()
    }
}
