//
//  SettingViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit
import RealmSwift
import Zip
import MobileCoreServices

 /*
 백업하기
 1. 사용자의 아이폰 저장 공간 확인
    - 부족할 경우: 백업 불가 안내
 2. 백업 진행
    - 어떤 데이터를 백업할 건지 확인(데이터가 존재하는지)
        - 데이터가 없는 경우라면, 백업할 데이터가 없다고 안내
    - 백업을 진행 중에, 사용자의 행동 핸들링(사용자가 백그라운드로 간다던가, 새로운 영화를 추가한다던가 하는)
        - 백그라운드 기능, Progress + UI 인터렉션 금지 등으로 처리가능
    - zip
        - 백업 완료 시점에 인터렉션 허용
    - 공유 화면 띄워주기
 */



/*
 복구하기
 - 저장 공간 확인
 - 파일 앱 열기
    - zip 파일 아닌 것들을 걸러줌
    - zip 선택
 - zip -> unzip
    - 백업 파일 이름 확인
    - 압축 해제
        - 백업 파일 확인: 폴더, 파일 이름 확인
        - 정상적인 파일인가
 - 백업 당시 데이터와 지금 앱에서 사용중인 데이터 어떻게 합칠 것인가
    - 백업 데이터 선택
 
 */


class SettingViewController: UIViewController {

    
    //MARK: Property
    
    
    
    //MARK: Method
    
    func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            return directoryPath
        } else {
            return nil
        }
    }
    
    // 7. 공유
    func presentActivityViewController() {
        // 압축파일 경로를 가져오기
        
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        
        
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backupButtonClicked(_ sender: UIButton) {
        
        // 4. 백업할 파일에 대한 URL 배열
        var urlPaths = [URL]()
        
        // 1. 도큐먼트 폴더 위치
        if let path = documentDirectoryPath() {
            
            // 2. 백업하고자 하는 파일 URL 확인
            // 이미지 같은 경우, 백업 편의성을 위해 폴더를 생성하고, 폴데 안에 이미지를 저장하는 것이 효율적
            let realm = (path as NSString).appendingPathComponent("default.realm")
            
            // 2. 백업하고자 하는 파일 존재 여부 확인
            if FileManager.default.fileExists(atPath: realm) {
                
                // 5. URL 배열에 백업 파일 URL 추가
                urlPaths.append(URL(string: realm)!)
            } else {
                print("DEBUG: 백업할 파일이 없습니다.")
            }
        }
        
        
        // 3. 4번 배열에 대해 압축파일 만들기
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive") // Zip
            
            presentActivityViewController()
            
            print("압축 경로: \(zipFilePath)")
        }
        catch {
          print("DEBUG: 압축파일 만들기 실패")
        }
        
        
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        presentActivityViewController()
    }
    
    @IBAction func restoreButtonClicked(_ sender: UIButton) {
        
        // 복구 1. 파일앱 열기 + 확장자
        // MobileCoreServices import
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizableStrings.tab_setting.localized
    }
    

}


extension SettingViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 2. 선택한 파일에 대한 경로 가져와야 함
        // iphone/y.b/fileapp/archive.zip
        guard let selectedFileUrl = urls.first else { return }
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("directory: \(directory)")
        let sandboxFileURL = directory.appendingPathComponent(selectedFileUrl.lastPathComponent)
        
        // 복구 - 3. 압축 해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            // 기존에 복구하고자 하는 zip 파일을 도큐먼트에 가지고 있을 경우, 도큐먼트에 위치한 zip 파일을 압축 해제 하면 된다.
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                try Zip.unzipFile(fileURL,
                                  destination: documentDirectory,
                                  overwrite: true,
                                  password: nil,
                                  progress: { progress in
                                    print(progress)
                                }, fileOutputHandler: { unzippedFile in
                                    print("unzip : \(unzippedFile)")
                                })
                
            } catch {
                print("DEBUG: 압축 해제 에러")
            }
            
        } else {
            // 파일 앱의 zip -> 도큐먼트 폴더에 복사
            do {
                try FileManager.default.copyItem(at: selectedFileUrl, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                try Zip.unzipFile(fileURL,
                                  destination: documentDirectory,
                                  overwrite: true,
                                  password: nil,
                                  progress: { progress in
                                    print(progress)
                                }, fileOutputHandler: { unzippedFile in
                                    print("unzip : \(unzippedFile)")
                                })
            } catch {
                print("DEBUG: 압축 해제 에러2")
            }
            
            
        }
    }
}
