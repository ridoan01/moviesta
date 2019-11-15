//
//  MovieDetailViewController.swift
//  Moviesta
//
//  Created by Ridoan Wibisono on 01/11/19.
//  Copyright © 2019 Ridoan Wibisono. All rights reserved.
//

struct MovieDetail {
    let title : String?
}

struct RelatedMovies {
    let id : Int?
    let title : String?
    let poster_url : String?
}

import UIKit
import SwiftyJSON

class MovieDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var backdrop_img: UIImageView!
    @IBOutlet weak var poster_img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var overview_tv: UITextView!
    @IBOutlet weak var release_lbl: UILabel!
    @IBOutlet weak var runtime_lbl: UILabel!
    @IBOutlet weak var rating_lbl: UILabel!
    @IBOutlet weak var _relatedMovies: UICollectionView!
    
    let rest = RestManager()
    var movie_id: Int = 13
    var related_page_max: Int = 0
    var related_page: Int = 1
    
    var movie:[MovieDetail]=[]
    var relatedList:[RelatedMovies]=[]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        print(movie_id)
        createdView()
        
    }
    
    func createdView(){
        _relatedMovies.delegate = self
        _relatedMovies.dataSource = self
        getDetail()
        getRelatedMovies()
        adjustUITextViewHeight(arg: overview_tv)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
//        arg.translatesAutoresizingMaskIntoConstraints = true
//        arg.sizeToFit()
//        arg.isScrollEnabled = false
        
        var newFrame = arg.frame
        let width = newFrame.size.width
        let newSize = arg.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        arg.frame = newFrame
    }
    
    
    
    func getDetail(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(movie_id)+"?api_key="+api_key) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                
                let val = try? JSON(data: data)
                
                let backdropUrl =  image_url+val!["backdrop_path"].stringValue
                let posterUrl = image_url+val!["poster_path"].stringValue
                
                
                DispatchQueue.main.async {
                    self.title_lbl.text = val!["title"].stringValue
                    self.backdrop_img.setImageFromUrl(ImageURL: backdropUrl)
                    self.poster_img.setImageFromUrl(ImageURL: posterUrl)
                    self.rating_lbl.text = String(format:"%.1f", val!["vote_average"].doubleValue)
                    self.runtime_lbl.text = String(val!["runtime"].intValue)+" Min"
                    let str = val!["release_date"].stringValue
                    let start = str.index(str.startIndex, offsetBy: 0)
                    let end = str.index(str.endIndex, offsetBy: -6)
                    let range = start..<end
                    self.release_lbl.text = String(str[range])
                    
                    self.overview_tv.text = val!["overview"].stringValue
                    
                }
            }
        }
    }
    
    
    func getRelatedMovies(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(movie_id)+"/similar?api_key="+api_key+"&language=null&page="+String(related_page)) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                
                let val = try? JSON(data: data)
                let res = val!["results"]
                self.related_page_max = val!["total_pages"].intValue
                self.relatedList.removeAll()
                res.array?.forEach({
                    (mv) in let movies = RelatedMovies(id: mv["id"].intValue,
                                                       title: mv["title"].stringValue,
                                                       poster_url: mv["poster_path"].stringValue)
                    self.relatedList.append(movies)
                })
                
                DispatchQueue.main.async {
                    self._relatedMovies.reloadData()
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as? RelatedMoviesViewCell else { return UICollectionViewCell() }
        
        let imgrl =  "https://image.tmdb.org/t/p/w500"+relatedList[indexPath.row].poster_url!
        
        cell.poster_img.setImageFromUrl(ImageURL: imgrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        movie_id = relatedList[indexPath.row].id!
        
        DispatchQueue.main.async {
            if self.related_page > self.related_page_max{
                self.related_page = 1
            }else{
                self.related_page = self.related_page + 1
            }
            self.createdView()
            
        }
    }
}

class RelatedMoviesViewCell: UICollectionViewCell {
    @IBOutlet weak var poster_img: UIImageView!
    
}
