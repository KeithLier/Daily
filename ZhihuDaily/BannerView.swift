//
//  BannerView.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/24.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    var delegate: BannerDelegate?
    
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    
    var currentPage: Int {
        var currentPage: Int
        let realPage = Int(collectionView.contentOffset.x / UIScreen.main.bounds.width)
        if realPage == 6 {
            currentPage = 0
        } else if realPage == 0 {
            currentPage = 4
        } else {
            currentPage = realPage - 1
        }
        return currentPage
    }
    
    var models = [BannerDataSource]() {
        didSet {
            collectionView.contentOffset.x = UIScreen.main.bounds.width
            collectionView.reloadData()
        }
    }

    var offsetY: CGFloat = 0 {
        didSet {
            collectionView.visibleCells.forEach { (cell) in
                guard let contentView = cell.contentView.subviews[0] as? BannerContentView else {
                    fatalError()
                }
                
                let imageView = contentView.imageView
                imageView.frame.origin.y = min(offsetY, 0)
                imageView.frame.size.height = max(frame.height - offsetY, frame.height)
                
                let label = contentView.label
                label.alpha = 1.6 - offsetY / label.frame.height
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
        setupPageControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: UIScreen.main.bounds.width, height: frame.height)
    }
}

extension BannerView {
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Banner")
        
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        addSubview(collectionView)
    }
    
    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 37, width: UIScreen.main.bounds.width, height: 37))
        pageControl.numberOfPages = 5
        
        addSubview(pageControl)
    }
}


extension BannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if models.count != 0 {
            return models.count + 2
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath)
        
        var index: Int
        
        if indexPath.row == 6 {
            index = 0
        } else if indexPath.row == 0 {
            index = 4
        } else {
            index = indexPath.row - 1
        }
        
        if !cell.contentView.subviews.isEmpty, let contentView = cell.contentView.subviews[0] as? BannerContentView {
            contentView.configureModel(model: models[index])
        } else {
            let contentView = BannerContentView(frame: CGRect(origin: .zero, size: cell.frame.size))
            
            contentView.configureModel(model: models[index])
            cell.contentView.addSubview(contentView)
        }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.red.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tapBanner(model: models[currentPage])
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        
//        let screenWidth = UIScreen.main.bounds.width
//        switch collectionView.contentOffset.x {
//        case 0:
//            collectionView.contentOffset.x = 5 * screenWidth
//            
//        case 6 * screenWidth:
//            collectionView.contentOffset.x = 1 * screenWidth
//            
//        default: break
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentPage
    }
    
}


protocol BannerDataSource {
    
    var bannerTitle: String { get }
    
    var bannerImageURL: URL? { get }
    var bannerImage: UIImage? { get }
}

protocol BannerDelegate {
    func tapBanner(model: BannerDataSource)
}
