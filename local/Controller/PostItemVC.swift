//
//  PostItemVC.swift
//  local
//
//  Created by Nozomi Okada on 12/18/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class PostItemVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageHelperView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextButton: MainButton!
    
    var crossButton: UIButton?
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        disableNextButton()
        createCrossButton()
    }
    
    func createCrossButton() {
        crossButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        crossButton?.layer.cornerRadius = 20
        crossButton?.backgroundColor = MAIN_COLOR
        crossButton?.setImage(UIImage(named: "cross.png"), for: .normal)
        crossButton?.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
    }
    
    func addCrossButton() {
        selectedImageHelperView.addSubview(crossButton!)
    }
    
    func removeCrossButton() {
        crossButton?.removeFromSuperview()
    }
    
    @objc func crossButtonTapped(_ sender:UIButton) {
        selectedImageView.image = nil
        removeCrossButton()
        checkRequiredFields()
    }
    
    func enableNextButton() {
        nextButton.alpha = 1.0
        nextButton.isEnabled = true
    }
    
    func disableNextButton() {
        nextButton.alpha = 0.5
        nextButton.isEnabled = false
    }
    
    func checkRequiredFields() {
        if titleTextField.text != "" && selectedImageView.image != nil {
            enableNextButton()
        } else {
            disableNextButton()
        }
    }
    
    @IBAction func chooseImageButtonTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func titleTextFieldEditingDidEnd(_ sender: Any) {
        checkRequiredFields()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let describeItemVC = segue.destination as? DescribeItemVC {
            describeItemVC.initData(image: selectedImageView.image!, title: titleTextField.text!)
        }
    }
}

extension PostItemVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        selectedImageView.image = resizeImage(image: selectedImage, newWidth: IMAGE_WIDTH)
        picker.dismiss(animated: true, completion: nil)
        addCrossButton()
        checkRequiredFields()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
