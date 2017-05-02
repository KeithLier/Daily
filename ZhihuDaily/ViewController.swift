//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/2.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,URLSessionTaskDelegate,URLSessionDelegate {

    @IBOutlet weak var tableView : UITableView!
    
    var news : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ceshi"
        getNews(newsURL: URL(string: "https://news-at.zhihu.com/api/4/news/latest")!)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cells")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cells")
        }
        let string = NSString(format: "row = %@", indexPath.section) as String
        cell?.textLabel?.text = string
        return cell!
    }
    
    private func getNews(newsURL:URL) {
        request(newsURL, method: .get).responseJSON { (response) in
            let dict : NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: response.data!) as! NSDictionary
            print(dict);
        }
    }
}

