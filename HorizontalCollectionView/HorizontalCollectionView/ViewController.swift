//
//  ViewController.swift
//  HorizontalCollectionView
//
//  Created by home on 2019/08/31.
//  Copyright © 2019 Swift-beginners. All rights reserved.
//

import UIKit
import Nuke

struct Item: Codable {
    var hits: [Hits]
    struct Hits: Codable {
        var user: String
        var previewURL: String
        var webformatURL: String
    }
}

class ViewController: UIViewController {

    private var items: Item?
    private let preheater = ImagePreheater()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
//
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        self.collectionView.prefetchDataSource = self
//
//        self.setUpPixabayItems()

        let refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
    }

    @objc func refresh(sender: UIRefreshControl) {
        self.setUpPixabayItems()
        sender.endRefreshing()
    }

    private func setUpPixabayItems() {
        self.getPixabayItems(completion: { (item) in
            self.items = item
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    private func getPixabayItems(completion: @escaping (Item) -> ()) {
        if let url = URL(string: "https://pixabay.com/api/?key=13068565-c1fdd03743ba0daf1922d861e&q=sea&image_type=photo") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {

                    do {
                        let decoder = JSONDecoder()
                        let items = try decoder.decode(Item.self, from: data)
                        completion(items)
                    } catch {
                        print("Serialize Error")
                    }
                } else {
                    print(error ?? "Error")
                }
            }
            task.resume()
        }
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TableViewCell else { return }
        
//        //ShopTableViewCell.swiftで設定したメソッドを呼び出す
//        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

//// セル選択時の処理
//extension ViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let url = URL(string: self.items?.hits[indexPath.row].webformatURL ?? "") {
//            UIApplication.shared.open(url)
//        }
//    }
//}
//
//// セルの大きさ
//extension ViewController:  UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let numberOfCell: CGFloat = 3
//        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell - 2
//        return CGSize(width: cellWidth, height: cellWidth)
//    }
//}
//
//extension ViewController: UICollectionViewDataSource {
//    // セルの数
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.items?.hits.count ?? 0
//    }
//
//    // セルの設定
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
//
//        cell.imageView.image = nil
//        cell.label.text = nil
//
//        let item = self.items?.hits[indexPath.row]
//        cell.label.text = item?.user
//        let previewUrl = URL(string: item?.previewURL ?? "")!
//        Nuke.loadImage(with: previewUrl, into: cell.imageView)
//
//        return cell
//    }
//}
//
//extension ViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths.map { URL(string: self.items?.hits[$0.row].previewURL ?? "") }
//        preheater.startPreheating(with: urls as! [URL])
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths.map { URL(string: self.items?.hits[$0.row].previewURL ?? "") }
//        preheater.stopPreheating(with: urls as! [URL])
//    }
//}

