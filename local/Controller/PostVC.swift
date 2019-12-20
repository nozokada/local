//
//  PostVC.swift
//  local
//
//  Created by Nozomi Okada on 12/18/19.
//  Copyright © 2019 RIR. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextButton: AppNavigationButton!
    
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
}

extension PostVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        selectedImageView.image = selectedImage
        if titleTextField.text != "" {
            enableNextButton()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
