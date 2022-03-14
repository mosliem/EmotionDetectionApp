//
//  RecommendationCell.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import UIKit

class RecommendationCell : UICollectionViewCell {
    static let identifier = "recommendationActivityCell"
    
    private let activityImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        return imageView
    }()
    

    private let ActivityName : UILabel = {
        let label = UILabel()
        label.text = "Test test"
        label.textColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
 
    private let ExpectedTime : UILabel = {
        let label = UILabel()
        label.text = "Test test"
        label.textColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1.0)
        label.numberOfLines = 0
        return label
    }()
    override init(frame : CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.94, alpha: 1.0)
        contentView.addSubview(activityImageView)
        contentView.addSubview(ActivityName)
        contentView.addSubview(ExpectedTime)
        contentView.layer.cornerRadius = 20
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ActivityName.text = nil
        activityImageView.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityImageView.sizeToFit()
        ActivityName.sizeToFit()
        ExpectedTime.sizeToFit()
        let imageSize : CGFloat = contentView.height - 10
        let albumNameLabelSize = ActivityName.sizeThatFits(
            CGSize(width: contentView.width - 10,
                   height: contentView.height-10)
        )
        
        activityImageView.frame = CGRect(
            x: 10, y: 5,
            width: imageSize,
            height: imageSize
        )

        
        let albumNameHeight = min(60 , albumNameLabelSize.height)
        
        ActivityName.frame = CGRect(
            x: activityImageView.right+20,
            y: 20,
            width: albumNameLabelSize.width,
            height: albumNameHeight
        )
        
        ExpectedTime.frame = CGRect(
            x: activityImageView.right+20,
            y: contentView.bottom - 30,
            width: albumNameLabelSize.width,
            height: 20
        )
        
    }
}
