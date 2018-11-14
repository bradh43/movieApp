//
//  MovieSearchViewController.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/16/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import UIKit

let tmdb = TMDB()



class MovieSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var movies: [Movie] = []
    var theImageCache: [UIImage] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let delta = (movieCollection.frame.width/3)-15
        
        return CGSize(width: delta, height: delta*1.5)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! movieCell
        if(indexPath[1] < theImageCache.count){
             cell.setImage(image: theImageCache[indexPath[1]])
        }
       
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        navigationItem.title = "Movies"
        movieCollection.register(movieCell.self, forCellWithReuseIdentifier: "movieCell")
        
        movieSearchBar.delegate = self
        movieCollection.delegate = self
        movieCollection.dataSource = self
        
        setUpMovieSearchPage()
        setUpAutoLayout()
        
        
    }
    
    func setUpMovieSearchPage(){
        view.addSubview(movieSearchBar)
        view.addSubview(movieCollection)
        movieCollection.addSubview(progressSpinner)
        progressSpinner.frame = view.frame
        progressSpinner.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
    }
    
    func setUpAutoLayout(){
        //enable auto layout
        movieSearchBar.translatesAutoresizingMaskIntoConstraints = false
        movieCollection.translatesAutoresizingMaskIntoConstraints = false
        
        
        //activate constraints
        NSLayoutConstraint.activate([
            movieSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            movieSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            movieSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            movieCollection.topAnchor.constraint(equalTo: movieSearchBar.bottomAnchor, constant: 0),
            movieCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            movieCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            movieCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            ])
    }
    
    
    let movieSearchBar: UISearchBar = {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let searchBar = UISearchBar(frame: frame)
        searchBar.barTintColor = UIColor.black
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        searchTextField?.textColor = UIColor.white
        searchTextField?.returnKeyType = UIReturnKeyType.done
        searchTextField?.textAlignment = .center
        searchTextField?.placeholder = "Search"
        
        let width = (searchTextField?.frame.width)!/2
        let height = (searchTextField?.frame.height)!
        let paddingFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let paddingView = UIView(frame: paddingFrame)
        searchTextField?.leftView = paddingView
        
        
        return searchBar
    }()
    
    let movieCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let frame = CGRect(x: 50, y: 50, width: 100, height: 30)
        let collection = UICollectionView(frame: frame, collectionViewLayout: collectionLayout)
        collection.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        
        return collection
    }()
    
    
    let progressSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        spinner.color = UIColor.white
        return spinner
    }()
    
    
    
    func cacheImages() {
        theImageCache = []
        var movieCount = 0
        for movie in movies {
            if(movieCount > 21) {
                break
            }
            if let path = movie.poster_path {
                let imagePath = tmdb.getImagePath(path: path)
                let url = URL(string: imagePath)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }
            movieCount += 1
        }
    }
    
    func fetchData(searchText: String) {
        tmdb.getSearchResults(searchText: searchText)
        if let dataRetrieved = tmdb.apiResults {
            self.movies = dataRetrieved.results
        }
        
    }
    
    
    
    
    
}


//Delegate for the movie search bar
extension MovieSearchViewController: UISearchBarDelegate {
    //function to get the search text as each time the textfield is changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.progressSpinner.isHidden = true
        self.progressSpinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.fetchData(searchText: searchText)
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
                
            }
        }
        
        self.progressSpinner.stopAnimating()
        self.progressSpinner.isHidden = true
        
    }
    
    //function to dismiss the keyboard when the done button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //function for clear button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        //center place holder text
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.textAlignment = .center
        searchTextField?.placeholder = "Search"
        let width = (searchTextField?.frame.width)!/2
        let height = (searchTextField?.frame.height)!
        let paddingFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let paddingView = UIView(frame: paddingFrame)
        searchTextField?.leftView = paddingView
    }
    
    //function to make the cancel button appear when editing begins
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.textAlignment = .left
        searchTextField?.leftView = nil
        
    }
    
   
}

extension MovieSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        
        let detailedMovieController = MovieDetailViewController()
        detailedMovieController.movie = self.movies[indexPath[1]]
        detailedMovieController.image = self.theImageCache[indexPath[1]]
        
        
        
        navigationController?.pushViewController(detailedMovieController, animated: true)
        
    }
    
    
    
    
}
