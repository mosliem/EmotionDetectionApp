//
//  TherapistInfoCell.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/14/22.
//

import UIKit

class TherapisInfoCell: UICollectionViewCell{
    static let identifer = "TherapisInfoCell"

    private let TherapistNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private let TherapistPicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    private let TherapistBioLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
//    private let cellView : UIView = {
//       let view = UIView()
//       view.backgroundColor = .cyan
//       return view
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        conigureCellShadow()
        
        contentView.addSubview(TherapistPicImageView)
        contentView.addSubview(TherapistNameLabel)
        contentView.addSubview(TherapistBioLabel)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        TherapistBioLabel.sizeToFit()
        TherapistPicImageView.frame = CGRect(x: 15, y: (contentView.height/4) - 25, width: 80, height: 80)
        TherapistNameLabel.frame = CGRect(x: TherapistPicImageView.right + 20, y: (contentView.height/4) - 30 , width: contentView.bounds.width - TherapistPicImageView.right, height: 30)
        TherapistBioLabel.frame = CGRect(x: TherapistPicImageView.right + 20, y: TherapistNameLabel.bottom + 5, width: contentView.width - TherapistPicImageView.right - 30, height: contentView.height - TherapistNameLabel.bottom - 10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        TherapistBioLabel.text = nil
        TherapistNameLabel.text = nil
        TherapistPicImageView.image = nil
    }
   private func conigureCellShadow(){
        layer.masksToBounds = false
    layer.shadowOpacity = 0.7
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.lightGray.cgColor
        
    contentView.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        contentView.layer.cornerRadius = 15
    }
    
    func configure(){
        TherapistBioLabel.text = "Compatibility with all devices able to run iOS 13.Home screen redesign with widgets.New App Library.App Clips.No full screen calls."
        TherapistNameLabel.text = "Dr/ Sara Adam"
        TherapistPicImageView.image = UIImage(named: "avatar")
    }
}
