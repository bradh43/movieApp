//
//  FavoritesViewController.swift
//  lab4
//
//  Created by Brad Hodkinson on 10/16/18.
//  Copyright © 2018 Brad Hodkinson. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource {
    
    var favoriteMovies: [Movie] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell")! as UITableViewCell
        
        movieCell.textLabel!.text = favoriteMovies[indexPath.row].title
        movieCell.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        movieCell.textLabel?.textColor = UIColor.white
        
    
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            favoriteMovies.remove(at: indexPath[1])
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteMovies), forKey:"movies")
            self.favoritesList.reloadData()
        }
    }
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        navigationItem.title = "Favorites"
        
        
        favoritesList.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        favoritesList.dataSource = self
        favoritesList.delegate = self
        
        setUpFavoritesPage()
        setUpAutoLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.value(forKey:"movies") as? Data {
            favoriteMovies = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.favoritesList.reloadData()
                
            }
        }
        
        
    }
    
    func setUpFavoritesPage() {
        view.addSubview(favoritesList)
        
        
    }
    
    func setUpAutoLayout(){
        //enable auto layout
        favoritesList.translatesAutoresizingMaskIntoConstraints = false
        
        //activate constraints
        NSLayoutConstraint.activate([
            favoritesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            favoritesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            favoritesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            favoritesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            ])
        
    }
    
    let favoritesList: UITableView = {
        
        let frame = CGRect(x: 50, y: 50, width: 100, height: 30)
        let table = UITableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.init(red: 87/255, green: 77/255, blue: 77/255, alpha: 1.0)
        
        return table
    }()
    
    
    
    
}


extension FavoritesViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let detailedMovieController = MovieDetailViewController()
        detailedMovieController.movie = self.favoriteMovies[indexPath[1]]
        if let path = self.favoriteMovies[indexPath[1]].poster_path {
            let imagePath = tmdb.getImagePath(path: path)
            let url = URL(string: imagePath)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            detailedMovieController.image = image!
        }
        
        
        navigationController?.pushViewController(detailedMovieController, animated: true)
        
    }
    

}


