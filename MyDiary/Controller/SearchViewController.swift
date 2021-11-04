//
//  SearchViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    
    
    //MARK: Property
    
    lazy var localRealm: Realm = {
        return try! Realm()
    }()
    
    var tasks: Results<Diary>!
    
    lazy var df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        df.locale = Locale(identifier: "ko-KR")
        df.timeZone = TimeZone(identifier: "KST")
        return df
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Method
    
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    func loadImageFromDocumenet(imageName: String) -> UIImage? {
        let documentPath = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let path = NSSearchPathForDirectoriesInDomains(documentPath, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }
    
    func deleteImageFromDocument(imageName: String) {
        //1. 어디에 저장할 지 경로 설정: 도큐먼트 폴더, File 관련된 것은 FileManager를 통해서 관리
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        let imageURL = documentPath.appendingPathComponent(imageName)
        
        
        //4. 이미지 저장하기 전 확인: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2. 존재한다면, 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지 삭제 실패")
            }
        }
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfig()
        title = LocalizableStrings.tab_search.localized
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        tasks = localRealm.objects(Diary.self)
        tableView.reloadData()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let data = tasks[indexPath.row]
        
        cell.title.text = data.title
        cell.title.font = UIFont().mainFontBold
        
        cell.contentLabel.text = data.content
        cell.contentLabel.font = UIFont().mainFontLight
        
        cell.dateLabel.text = "2021. 11. 1"
        cell.dateLabel.font = UIFont().mainFontLight
        cell.dateLabel.textColor = .gray
        
        
        cell.pictureImage.image = loadImageFromDocumenet(imageName: "\(data._id).jpg")
        cell.pictureImage.backgroundColor = .gray
        cell.pictureImage.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 원래는 화면 전환 + 값 전달 후 새로운 화면에서 수정이 적합
        
        let task = tasks[indexPath.row]
        
        let sb = UIStoryboard(name: "Detail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.diary = DiaryModel(title: task.title, content: task.content!, image: loadImageFromDocumenet(imageName: "\(task._id).jpg"))
        vc.title = df.string(from: task.writtenDate) + "일기"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = tasks[indexPath.row]
        
        try! localRealm.write {
            // 아이디를 이용해서 image 이름을 정했으니까, 도큐먼트에 있는 이미지를 먼저 지워줘야함!
            deleteImageFromDocument(imageName: "\(row._id).jpg")
            localRealm.delete( row )
            tableView.reloadData()
        }
    }
    
    
}
