//
//  FeedCell.swift
//  FacebookNewsFeed
//
//  Created by MacBookPro on 1/15/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import Foundation
import UIKit



class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    var post: Post? {
        didSet {
            statusImageView.image = nil
            
            /*if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
            }*/
            
            if let statusImageUrl = post?.statusImageUrl {
                
                let url = URL(string: statusImageUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        self.statusImageView.image = image
                        self.loader.stopAnimating()
                    }
                }).resume()
                
            }
            
            setupNameLocationStatusAndProfileImage()
        }
    }
    
    private func setupNameLocationStatusAndProfileImage() {
        if let name = post?.name {
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\nDecember 18 • San Francisco • ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, greeen: 161, blue: 171)]))
            
            let paragraphtStyle = NSMutableParagraphStyle()
            paragraphtStyle.lineSpacing = 4
            
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphtStyle, range: NSMakeRange(0, attributedText.length))
            
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "earth_globe")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
        }
        
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImageName = post?.profileImageName {
            profileImageView.image = UIImage(named: profileImageName)
        }
        
        
        
        if let likes = post?.numLikes, let comments = post?.numComments {
            likesCommentsLabel.text = "\(likes) Likes    \(comments) Comments"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loader.startAnimating()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "zuck_image")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Some random text for status goes here"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes     34 Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, greeen: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, greeen: 228, blue: 232)
        return view
    }()
    
    let loader: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        iv.startAnimating()
        iv.hidesWhenStopped = true
        return iv
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, greeen: 150, blue: 163), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    @objc func animate() {
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        addSubview(loader)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-|", views: profileImageView, nameLabel)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: statusTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: likesCommentsLabel)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: loader)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        //8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.5)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: loader)
    }
}
