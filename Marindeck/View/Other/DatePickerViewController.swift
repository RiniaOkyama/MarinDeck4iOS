//
//  DatePickerViewController.swift
//  Marindeck
//
//  Created by a on 2022/02/21.
//

import UIKit

final class DatePickerViewController: UIViewController {

    private var completion: ((Date) -> Void)? = nil

    lazy var datePicker: UIDatePicker = { [weak self] in
        let dp = UIDatePicker()
        dp.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        return dp
    }()

    required init(mode: UIDatePicker.Mode, date: Date = Date(), completion: ((Date)->Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        datePicker.datePickerMode = mode
        datePicker.date = date
        self.completion = completion
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func loadView() {
        view = UIView()
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 6),
            view.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    @objc func actionForDatePicker() {
        completion?(datePicker.date)
    }
}
