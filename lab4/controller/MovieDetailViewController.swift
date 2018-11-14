//
//  MovieDetailViewController.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/22/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailViewController: UIViewController  {
    
    
    var movie: Movie!
    var image: UIImage!
    var scrollView = UIScrollView()
    var mainView = UIView()
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        
        displayMovieDetails()
        setUpAutoLayout()
        
    }
    
    func displayMovieDetails(){
        
        let mainFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mainView = UIView(frame: mainFrame)
        
        view.addSubview(scrollView)
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.addSubview(mainView)
        
        
        //set navigation title
        navigationItem.title = movie.title
        
        //set image view of the movie
        mainView.addSubview(movieView)
        movieView.image = image
        
        //set release label
        mainView.addSubview(releaseLabel)
        let movieDate = movie.release_date
        let movieYear = movieDate.prefix(4)
        releaseLabel.text = "Released: \(movieYear)"
        
        //set score
        mainView.addSubview(scoreLabel)
        let score = Int(movie.vote_average*10)
        scoreLabel.text = "Rating: \(score)/100"
        
        
        //set overview
        mainView.addSubview(overviewLabel)
        let overview = movie.overview
        overviewLabel.text = "Description: \(overview)"

        
        
        //set favorites button
        mainView.addSubview(addFavoritesButton)
        
    }
    
    func setUpAutoLayout(){
        //enable auto layout
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        movieView.translatesAutoresizingMaskIntoConstraints = false
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        //activate constraints
        NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
           scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
           scrollView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),

            movieView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            movieView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            movieView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            movieView.heightAnchor.constraint(equalToConstant: (view.frame.height/2)-100),
            
            releaseLabel.topAnchor.constraint(equalTo: movieView.bottomAnchor, constant: 10),
            releaseLabel.leadingAnchor.constraint(equalTo: movieView.leadingAnchor, constant: 0),
            releaseLabel.trailingAnchor.constraint(equalTo: movieView.trailingAnchor, constant: 0),
            releaseLabel.heightAnchor.constraint(equalToConstant: 30),
            
            scoreLabel.topAnchor.constraint(equalTo: releaseLabel.bottomAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: movieView.leadingAnchor, constant: 0),
            scoreLabel.trailingAnchor.constraint(equalTo: movieView.trailingAnchor, constant: 0),
            scoreLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            addFavoritesButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            addFavoritesButton.leadingAnchor.constraint(equalTo: movieView.leadingAnchor, constant: 10),
            addFavoritesButton.trailingAnchor.constraint(equalTo: movieView.trailingAnchor, constant: -10),
            addFavoritesButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            overviewLabel.topAnchor.constraint(equalTo: addFavoritesButton.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: movieView.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: movieView.trailingAnchor, constant: -10),

            ])
    }
    
    
    let movieView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let releaseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    
    let overviewLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 600)
        let label = UILabel(frame: frame)
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 15
        label.sizeToFit()
        label.textColor = UIColor.white
        label.insetsLayoutMarginsFromSafeArea = true
        return label
    }()
    
    let addFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to favorites", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.init(red: 131/255, green: 16/255, blue: 16/255, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addMovieToFavorites(_:)), for: UIControl.Event.touchDown)
        return button
    }()
    
    @objc func addMovieToFavorites(_ sender: Any?){
        var movies: [Movie] = []
        if let data = UserDefaults.standard.value(forKey:"movies") as? Data {
            movies = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        movies.append(movie)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(movies), forKey:"movies")
    }
    
    
    override func viewDidLayoutSubviews()
    {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height*1.2)
    }
    

}
