//
//  PopularMoviesViewController.swift
//  Moviesta
//
//  Created by Ridoan Wibisono on 01/11/19.
//  Copyright © 2019 Ridoan Wibisono. All rights reserved.
//

struct PopularMovieList {
    let movie_id : Int?
    let movie_title: String?
    let movie_poster : String?
}


import UIKit
import SwiftyJSON

class PopularMoviesViewController: UIViewController {
    
    @IBOutlet weak var _movie_collection: UICollectionView!
    let rest = RestManager()
    
    var movieList:[PopularMovieList]=[]
    
    var themovie_id = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createView()
    }
    
    func createView(){
        _movie_collection.dataSource = self
        _movie_collection.delegate = self
        
        getPopularMovie()
    }
    
    func getPopularMovie(){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key="+api_key+"&language=en-US&page=1") else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                
                let val = try? JSON(data: data)
                let res =  val!["results"]
                
                res.array?.forEach({
                    (mv) in let movie = PopularMovieList(movie_id: mv["id"].intValue,
                                                         movie_title: mv["title"].stringValue,
                                                         movie_poster: mv["poster_path"].stringValue)
                    self.movieList.append(movie)
                })
                
                DispatchQueue.main.async {
                    self._movie_collection.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : MovieDetailViewController = segue.destination as! MovieDetailViewController
        destVC.movie_id = themovie_id
    }
    
}

extension PopularMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
        
        let imgrl =  "https://image.tmdb.org/t/p/w500"+movieList[indexPath.row].movie_poster!
        
        cell.poster_img.setImageFromUrl(ImageURL: imgrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row].movie_id
        //        let movieDetailsVC = MovieDetailViewController()
        //        movieDetailsVC.movie_id = movie!
        //        let navController = UINavigationController(rootViewController: movieDetailsVC)
        //        navController.modalPresentationStyle = .fullScreen
        //        present(navController, animated: true, completion: nil)
        
        //        let detailVC = MovieDetailViewController()
        //        detailVC.movie_id = movie!
        //        detailVC.modalPresentationStyle = .fullScreen
        //        detailVC.view.backgroundColor = UIColor.white
        //        present(detailVC, animated: true)
        
        themovie_id = movie!
        
        performSegue(withIdentifier: "goDetail", sender: self)
        
    }
}

extension UIImageView{
    func setImageFromUrl(ImageURL :String) {
        URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }
}
