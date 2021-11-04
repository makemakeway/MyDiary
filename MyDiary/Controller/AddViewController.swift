//
//  AddViewController.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit
import RealmSwift
import SwiftUI

class AddViewController: UIViewController {
    
    
    
    //MARK: Property
    
    let localRealm = try! Realm()
    
    @IBOutlet weak var pictureImage: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    //MARK: Method
    
    func saveImageToDocument(imageTitle: String, image: UIImage) {
        //1. 어디에 저장할 지 경로 설정: 도큐먼트 폴더, File 관련된 것은 FileManager를 통해서 관리
        
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        let imageURL = documentPath.appendingPathComponent(imageTitle)
        
        
        //3. 이미지 압축 (압축하고 싶으면 jpeg, 아니면 png)
        guard let data = image.jpegData(compressionQuality: 0.2) else {
            print("이미지 압축 실패")
            return
        }
        
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
        
        //5. 이미지 저장
        do {
            try data.write(to: imageURL)
            print("이미지 저장 완료")
        } catch {
            print("이미지 저장 실패")
        }
    }
    
    func presentImagePicker(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func addPhotoButtonConfig() {
        let cornerRadius = addPhotoButton.frame.size.width / 2
        addPhotoButton.layer.cornerRadius = cornerRadius
        addPhotoButton.backgroundColor = .lightGray
    }
   
    func presentActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "촬영", style: .default) { [weak self](_) in
            self?.presentImagePicker(type: .camera)
        }
        let library = UIAlertAction(title: "앨범", style: .default) { [weak self](_) in
            self?.presentImagePicker(type: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonClicked(_ sender: UIButton) {
        presentActionSheet()
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let task = Diary(title: titleTextField.text!, content: contentTextView.text!, writtenDate: Date(), publishedDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
            
            if let image = self.pictureImage.image {
                saveImageToDocument(imageTitle: "\(task._id).jpg", image: image)
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    
    //MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addPhotoButtonConfig()
    }

}

extension AddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage? = nil
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image // 이미지를 수정했을 경우
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image // 원본 이미지일 경우
        }
        self.pictureImage.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}
