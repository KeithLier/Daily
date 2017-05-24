//
//  StoryCell.swift
//  ZhihuDaily
//
//  Created by keith on 2017/5/24.
//  Copyright © 2017年 keith. All rights reserved.
//

import UIKit

@IBDesignable
class StoryCell: UITableViewCell {

    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var story: Story! {
        didSet {
            self.titleLabel.text = story.title;
//            self.thumbNail.af_setImage(withURL: story.thumbnailURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for story: Story) {
        self.story = story
    }
}
