//
//  MovieDetailsVC.swift
//  Moviesta
//
//  Created by Ridoan Wibisono on 04/11/19.
//  Copyright © 2019 Ridoan Wibisono. All rights reserved.
//

import UIKit
import SwiftyJSON


struct MovieDetails {
    let id : Int?
    let title : String?
    let release: String?
    let runtime: Int?
    let rating: Double?
    let story_line: String?
    let poster_url: String?
    let backdrop_url: String?
}

struct CastLists {
    let id: Int?
    let name: String?
    let character: String?
    let image_url: String?
}


class MovieDetailsVC: UIViewController {

    @IBOutlet weak var _detail_tbl: UITableView!
    
    
    let rest = RestManager()
    var detail:[MovieDetails] = []
    var relatedList:[RelatedMovies]=[]
    
    public var movie_id:Int? = 19404
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie_id)
        UserDefaults.standard.removeObject(forKey: "movie_id")
        createView()
    }
    
    func createView(){
         
        _detail_tbl.delegate = self
        _detail_tbl.dataSource = self
        getDetail()
    }

    func getDetail(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(movie_id!)+"?api_key="+api_key) else { return }
         
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if let data = results.data {
                
                let val = try? JSON(data: data)
                print(val)
                
                
                if (val!["status_code"].exists()){
                    let vd =  MovieDetails(id: 0,
                                           title: "",
                                           release: "",
                                           runtime: 0,
                                           rating: 0,
                                           story_line: "",
                                           poster_url: "",
                                           backdrop_url: "")
                    self.detail.append(vd)
                    print(val!["status_code"])
                }
                  
                else {
                
                let vd = MovieDetails(id: val!["id"].intValue,
                                            title: val!["title"].stringValue,
                                            release: val!["release_date"].stringValue,
                                            runtime: val!["runtime"].intValue,
                                            rating: val!["vote_average"].doubleValue,
                                            story_line: val!["overview"].stringValue,
                                            poster_url: val!["poster_path"].stringValue,
                                            backdrop_url: val!["backdrop_path"].stringValue)
                
                self.detail.append(vd)
                
            
                UserDefaults.standard.set(val!["id"].intValue, forKey: "movie_id")
//                print(self.detail)
                }
                
                DispatchQueue.main.async {
                   
//                    self._detail_tbl.reloadData()
                   
                }
            }
        }
    }
    
}


extension MovieDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
//        if (self.detail.count == 0){
//                             let vd =  MovieDetails(id: 0,
//                                                    title: "",
//                                                    release: "",
//                                                    runtime: 0,
//                                                    rating: 0,
//                                                    story_line: "",
//                                                    poster_url: "",
//                                                    backdrop_url: "")
//                             self.detail.append(vd)
//
//                         }
        
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell") as? FirstTableViewCell
                else { return UITableViewCell()}
            
            
            
            cell.title_lbl.text = detail[indexPath.row].title
            cell.story_txv.text = detail[indexPath.row].story_line
            cell.rating_lbl.text = String(format:"%.1f", detail[indexPath.row].rating!)
            let (h,m) = secondsToHoursMinutes(seconds: detail[indexPath.row].runtime!)

            cell.runtime_lbl.text = String(h)+"h "+String(m)+"m"

            let str = detail[indexPath.row].release!

            if(str.count > 6){
            let start = str.index(str.startIndex, offsetBy: 0)
            let end = str.index(str.endIndex, offsetBy: -6)
            let range = start..<end

            cell.release_lbl.text = String(str[range])
            }
            let backdropUrl =  image_url+detail[indexPath.row].backdrop_url!
            let posterUrl = image_url+detail[indexPath.row].poster_url!

            cell.backdrop_img.setImageFromUrl(ImageURL: backdropUrl)
            cell.poster_img.setImageFromUrl(ImageURL: posterUrl)

            return cell
        }
        else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell") as? SecondTableViewCell
                else { return UITableViewCell()}
            
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell") as? ThirdTableViewCell
                else { return UITableViewCell()}
            
            
            return cell
        }
    }
    
    
}

class FirstTableViewCell: UITableViewCell {
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var backdrop_img: UIImageView!
    @IBOutlet weak var poster_img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var release_lbl: UILabel!
    @IBOutlet weak var runtime_lbl: UILabel!
    @IBOutlet weak var rating_lbl: UILabel!
    @IBOutlet weak var story_txv: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        adjustUITextViewHeight(arg: story_txv)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
}

class SecondTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
  
    
    @IBOutlet weak var bg_vw: UIView!
  
    var lists: [CastLists]=[]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as? RelatedMoviesViewCell else { return UICollectionViewCell() }
        return cell
      }
    
}

class ThirdTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
   
    @IBOutlet weak var _relatec_coll: UICollectionView!
    let rest = RestManager()
    var relatedList:[RelatedMovies]=[]
    var movie_id  = UserDefaults.standard.integer(forKey: "movie_id")
    
    var related_page_max: Int = 0
    var related_page: Int = 1
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _relatec_coll.delegate = self
        _relatec_coll.dataSource = self
        print(movie_id)
        getRelatedMovies()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                    self._relatec_coll.reloadData()
                       
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
}

func secondsToHoursMinutes (seconds : Int) -> (Int, Int) {
  return (seconds / 60, (seconds % 60))
}


