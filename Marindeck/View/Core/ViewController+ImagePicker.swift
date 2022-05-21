//
//  ViewController+ImagePicker.swift
//  Marindeck
//
//  Created by a on 2022/02/05.
//
import UIKit
import Loaf

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            guard let url = info[.imageURL] as? URL else { return }
            let pex = url.pathExtension

            var base64imgString = ""
            if pex == "png" {
                base64imgString = image.pngData()?.base64EncodedString(options: []) ?? ""
            } else if pex == "jpg" || pex == "jpeg" {
                base64imgString = image.jpegData(compressionQuality: 0.7)?.base64EncodedString(options: []) ?? ""
            }

            if base64imgString == "" {
                // TODO: L10n
                Loaf("画像が読み込めませんでした。", state: .error, location: .top, sender: self).show()
                return
            }

            print(pex)
            print(url.lastPathComponent)
            print(base64imgString.count)
            UIPasteboard.general.string = base64imgString
            webView.evaluateJavaScript("window.MarinDeckInputs.addTweetImage(\"data:image/\(pex);base64,\(base64imgString)\", \"image/\(pex)\", \"\(url.lastPathComponent)\")") { _, error in
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
