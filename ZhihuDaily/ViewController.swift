//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/2.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,URLSessionTaskDelegate,URLSessionDelegate {

    @IBOutlet weak var tableView : UITableView!
    let cellId = "StoryCell"
    
    var news = [News]() {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.insertSections(IndexSet(integer: self.news.count - 1), with: .top)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ceshi"
        getNews(newsURL: News.latestNewsURL)
        let nib = UINib(nibName: "StoryCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news[section].stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    } 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? StoryCell
        cell?.thumbNail.image = nil
        cell?.configure(for: news[indexPath.section].stories[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.textLabel?.text = news[section].beautifulDate
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        } else {
            return 0
        }
    }
    
    private func getNews(newsURL:URL) {
        request(newsURL, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                do {
                    guard let json = json as? JSONDictionary else {
                        return
                    }
                    let news = try News.parse(json: json)
                    self.news.append(news)
                    if self.news.count == 1 {
                        
                    }
                } catch {
                    fatalError("JSON Data Error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

