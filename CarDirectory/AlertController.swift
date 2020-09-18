//
//  AlertController.swift
//  CarDirectory
//
//  Created by Vladislav on 18.09.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {

    func action(car: Car?, completion: @escaping ([String]) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            var newDetails = [String]()
            
            self.textFields?.forEach({ textField in
                newDetails.append((textField.text ?? ""))
            })
            
            completion(newDetails)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { manufacturerTextField in
            manufacturerTextField.placeholder = "Manufacturer"
            manufacturerTextField.text = car?.manufacturer
        }
        addTextField { modelTextField in
            modelTextField.placeholder = "Model"
            modelTextField.text = car?.model
        }
        addTextField { yearTextField in
            yearTextField.placeholder = "Year of issue"
            yearTextField.text = car?.year
            yearTextField.keyboardType = .numberPad
        }
        addTextField { bodyTypeTextField in
            bodyTypeTextField.placeholder = "Body type"
            bodyTypeTextField.text = car?.bodyType
        }
    }
}
