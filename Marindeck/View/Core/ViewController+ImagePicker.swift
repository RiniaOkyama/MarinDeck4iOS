//
//  ViewController+ImagePicker.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//
import UIKit

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else {
                return
            }
            webView.evaluateJavaScript("window.MarinDeckInputs.addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { _, error in
                print("photoselected : ", error ?? "成功")
            }
            dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            guard let base64img = image.pngData()?.base64EncodedString(options: []) else {
                return
            }
            webView.evaluateJavaScript("window.MarinDeckInputs.addTweetImage(\"data:image/png;base64,\(base64img)\", \"image/png\", \"test.png\")") { _, error in
                print("photoselected : ", error ?? "成功")
            }
        } else {
            print("Error")
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
