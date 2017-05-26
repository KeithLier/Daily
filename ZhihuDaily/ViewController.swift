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

    var bannerHeight: CGFloat = 200
    
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var tableView: UITableView!
    let cellId = "StoryCell"
    
    var navigationBarBackgroundImage: UIView? {
        return (navigationController?.navigationBar.subviews.first)
    }
    
    var navigationBarAlpha: CGFloat {
        return (tableView.contentOffset.y - 64 ) / bannerHeight
    }
    
    var topStories = [BannerDataSource]() {
        didSet {
            bannerView.models = topStories
        }
    }
    
    var news = [News]() {
        didSet {
            OperationQueue.main.addOperation {
                self.tableView.insertSections(IndexSet(integer: self.news.count - 1), with: .top)
            }
        }
    }
    
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "知乎日报"
        setupNavigationBar()
        setupTableView()
        setupBannerView()
        
        loadLatestNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarBackgroundImage!.alpha = navigationBarAlpha
    }
}

extension ViewController {
    
    fileprivate func setupNavigationBar() {
        let bar = navigationController?.navigationBar
        
        bar?.titleTextAttributes = [NSForegroundColorAttributeName: Theme.white]
        bar?.shadowImage = UIImage()
        bar?.isTranslucent = false
        bar?.barTintColor = Theme.mainColor
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "StoryCell", bundle: nil) //nibName指的是我们创建的Cell文件名
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        tableView.rowHeight = 101
        tableView.estimatedRowHeight = 101
        tableView.contentInset.top = -64
        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
        tableView.clipsToBounds = false
        tableView.backgroundColor = Theme.white
    }
    
    fileprivate func setupBannerView() {
        bannerView.delegate = self as BannerDelegate
    }
}

// Get Data
extension ViewController {
    
    fileprivate func loadLatestNews() {
        getNews(newsURL: News.latestNewsURL)
    }
    
    fileprivate func loadPreviousNews() {
        getNews(newsURL: news.last!.previousNewsURL)
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
                        self.updateTopStories()
                    }
                } catch {
                    fatalError("JSON Data Error")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateTopStories() {

        topStories = news[0].topStories!.map({ (story) -> BannerDataSource in
            return story as BannerDataSource
        })
    }
}

// tableView delegate datasource
extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news[section].stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
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
        header?.textLabel?.textColor = Theme.white
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        header?.layer.backgroundColor = Theme.mainColor.cgColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StoryCell
        
        gotoDetail(story: cell.story)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == news.count - 1 && indexPath.row == 0 {
            loadPreviousNews()
        }
        
        OperationQueue().addOperation {
            let displaySection = tableView.indexPathsForVisibleRows?.reduce(Int.max, { (partialResult, indexPath) -> Int in
                return min(partialResult, indexPath.section)
            })
            
            if displaySection == 0 {
                OperationQueue.main.addOperation {
                    self.navigationItem.title = "今日热文"
                }
            } else {
                OperationQueue.main.addOperation {
                    self.navigationItem.title = self.news[displaySection!].beautifulDate
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        navigationBarBackgroundImage!.alpha = navigationBarAlpha
        
        if !news.isEmpty {
            bannerView.offsetY = scrollView.contentOffset.y - 64
        }
    }
}

extension ViewController {
    
    func configureBannerView() {
        bannerView.models = topStories.map({ (story) -> BannerDataSource in
            return story as BannerDataSource
        })
    }
    
    func gotoDetail(story: Story) {
        let detail = DetailViewController()
        detail.story = story
        navigationController?.pushViewController(detail, animated: true)

    }
}

extension ViewController: BannerDelegate {
    
    func tapBanner(model: BannerDataSource) {
        guard let story = model as? Story else {
            fatalError()
        }
        
        gotoDetail(story: story)
    }
}
