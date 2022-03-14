//
//  recordedCallsCell.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/13/22.
//

import UIKit

class recordedCallCell: UICollectionViewCell {
    
    static let identifier: String = "recordedCallCell"
    
    
    
    private let contactNameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let callDateLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private let ContactImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let CallMoodImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emoji")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.backgroundColor = .red
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(contactNameLabel)
        contentView.addSubview(callDateLabel)
        contentView.addSubview(ContactImageView)
        contentView.addSubview(CallMoodImageView)
        contentView.backgroundColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.94, alpha: 1.0)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contactNameLabel.sizeToFit()
        ContactImageView.sizeToFit()
        callDateLabel.sizeToFit()
        
        let imageSize : CGFloat = contentView.height-10
        
        ContactImageView.frame = CGRect(
            x: 15, y:5 ,
            width: imageSize,
            height: imageSize
        )
        
        contactNameLabel.frame = CGRect(
            x: ContactImageView.right + 13, y: 5 ,
            width: contentView.width - ContactImageView.right - 10,
            height: 40
        )
        callDateLabel.frame = CGRect(
            x: ContactImageView.right + 13, y: contactNameLabel.bottom  ,
            width: contentView.width - ContactImageView.right - 10,
            height: 20)
      
          CallMoodImageView.frame = CGRect(
            x: contentView.right - imageSize - 15, y:5 ,
            width: imageSize,
            height: imageSize
        )
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        callDateLabel.text = nil
        contactNameLabel.text = nil
        ContactImageView.image = nil
        
    }
    
    func configure(model: [RecordedCallModel] , index: Int){
        contactNameLabel.text = "Testing Testing"
        callDateLabel.text = "15/1/2022"
        ContactImageView.image = UIImage(named: "avatar")
    }
}
