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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextButton: MainButton!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        disableNextButton()
        addTapToView()
    }
    
    func addTapToView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func enableNextButton() {
        nextButton.alpha = 1.0
        nextButton.isEnabled = true
    }
    
    func disableNextButton() {
        nextButton.alpha = 0.5
        nextButton.isEnabled = false
    }
    
    @IBAction func chooseImageButtonTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func titleTextFieldEditingDidEnd(_ sender: Any) {
        if titleTextField.text != "" && selectedImageView.image != nil {
            enableNextButton()
        }
        else {
            disableNextButton()
        }
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
        if titleTextField.text != "" {
            enableNextButton()
        }
        picker.dismiss(animated: true, completion: nil)
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
