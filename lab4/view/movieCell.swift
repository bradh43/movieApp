//
//  movieCell.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/21/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import Foundation
import UIKit

class movieCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMovieCellViews()
    }
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func setImage(image: UIImage){
        movieImageView.image = image
    }
    
    func setUpMovieCellViews() {
        backgroundColor = UIColor.red
        
        addSubview(movieImageView)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

