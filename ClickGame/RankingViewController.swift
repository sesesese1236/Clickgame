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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if(now == 0){
            count = levelDistinctList.count
            btnDelete.isEnabled = false
        }else{
            if(count == 0){
                btnDelete.isEnabled = false
            }else{
                btnDelete.isEnabled = true
            }
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
            cell.textLabel?.text = "Time: \(rankingList![indexPath.row].scoreTime)"
        }
        return cell
    }
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        if(now == 0){
            selectedLevel = Int(levelDistinctList[indexPath.row])!
            
            now = 1
            btnBack.isEnabled = true
            
            let realm = try! Realm()
            rankingList = realm.objects(ClearTime.self).filter("Level = \(selectedLevel)")
            rankingList = rankingList!.sorted(byKeyPath: "scoreTime")
            
            tableView.reloadData()
        }
        else if(now == 1){
//            Name = nameList![indexPath.row].Name
//            Id = nameList![indexPath.row].id
//            indexS = indexPath.row
        }
    }
    var rankingList:Results<ClearTime>?=nil
    @IBOutlet weak var rankingView: UITableView!
    var levelDistinctList = [String]()
    var now = 0
    var selectedLevel = 0
    
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
        
        btnBack.isEnabled = false
    }
    @IBAction func Back(_ sender: UIButton) {
        if(now == 1){
            now = 0
            
            rankingView.reloadData()
        }
    }
}
