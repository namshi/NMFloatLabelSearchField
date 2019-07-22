//
//  ViewController.swift
//  NMFloatLabelSearchField
//
//  Created by Noor on 03/11/2018.
//  Copyright (c) 2018 Namshi. All rights reserved.
//

import UIKit
import NMFloatLabelSearchField

class ViewController: UIViewController {
    
    @IBOutlet weak var simpleSearchField : NMFloatLabelSearchField!
    @IBOutlet weak var customSearchField : NMFloatLabelSearchField!
    @IBOutlet weak var simpleInlineSearchField : NMFloatLabelSearchField!
    @IBOutlet weak var customInlineSearchField : NMFloatLabelSearchField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 - Configure a simple search text field
        configureSimpleSearchTextField()
        
        // 2 - Configure a custom search text field
        configureCustomSearchTextField()
        
        // 3 - Configure an "inline" suggestions search text field
        configureSimpleInLineSearchTextField()
        
        // 4 - Configure a custom "inline" suggestions search text field
        configureCustomInLineSearchTextField()
    }
    
    // 1 - Configure a simple search text view
    fileprivate func configureSimpleSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        simpleSearchField.startVisibleWithoutInteraction = true
        
        // Set data source
        let countries = localCountries()
        simpleSearchField.filterStrings(countries)
    }
    
    
    // 2 - Configure a custom search text view
    fileprivate func configureCustomSearchTextField() {
        // Set theme - Default: light
        customSearchField.theme = NMFloatLabelSearchFieldTheme.lightTheme()
        
        // Define a header - Default: nothing
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: customSearchField.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Pick your option"
        customSearchField.resultsListHeader = header
        
        
        // Modify current theme properties
        customSearchField.theme.font = UIFont.systemFont(ofSize: 12)
        customSearchField.theme.bgColor = UIColor.lightGray.withAlphaComponent(0.5)
        customSearchField.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        customSearchField.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        customSearchField.theme.cellHeight = 50
        customSearchField.theme.placeholderColor = UIColor.lightGray
        
        // Max number of results - Default: No limit
        customSearchField.maxNumberOfResults = 5
        
        // Max results list height - Default: No limit
        customSearchField.maxResultsListHeight = 200
        
        // Set specific comparision options - Default: .caseInsensitive
        customSearchField.comparisonOptions = [.caseInsensitive]
        
        // You can force the results list to support RTL languages - Default: false
        customSearchField.forceRightToLeft = false
        
        // Customize highlight attributes - Default: Bold
        customSearchField.highlightAttributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        
        // Handle item selection - Default behaviour: item title set to the text field
        customSearchField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.customSearchField.text = item.title
        }
        
        // Update data source when the user stops typing
        customSearchField.userStoppedTypingHandler = {
            if let criteria = self.customSearchField.text {
                if criteria.count > 1 {
                    
                    // Show loading indicator
                    self.customSearchField.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.customSearchField.filterItems(results)
                        
                        // Stop loading indicator
                        self.customSearchField.stopLoadingIndicator()
                    }
                }
            }
            } as (() -> Void)
    }
    
    // 3 - Configure a simple inline search text view
    fileprivate func configureSimpleInLineSearchTextField() {
        // Define the inline mode
        simpleInlineSearchField.inlineMode = true
        
        
        // Set data source
        let countries = localCountries()
        simpleInlineSearchField.filterStrings(countries)
    }
    
    // 4 - Configure a custom inline search text view
    fileprivate func configureCustomInLineSearchTextField() {
        // Define the inline mode
        customInlineSearchField.inlineMode = true
        
        customInlineSearchField.startFilteringAfter = "@"
        customInlineSearchField.startSuggestingInmediately = true
        
        // Set data source
        customInlineSearchField.filterStrings(["gmail.com", "yahoo.com", "yahoo.com.ar", "hotmail.com"])
    }
    
    // Hide keyboard when touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    ////////////////////////////////////////////////////////
    // Data Sources
    
    fileprivate func localCountries() -> [String] {
        return ["America", "Bhutan", "China", "Denmark", "England", "Finland", "Greece", "Hungary", "India", "Jordan", "Pakistan", "UAE", "United Kingdom"]
    }
    
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [NMFloatLabelSearchFieldItem]) -> Void)) {
        let url = URL(string: "http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=\(criteria)")
        
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                do {
                    if let data = data {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
                        
                        if let firstElement = jsonData.first {
                            let jsonResults = firstElement["lfs"] as! [[String: AnyObject]]
                            
                            var results = [NMFloatLabelSearchFieldItem]()
                            
                            for result in jsonResults {
                                results.append(NMFloatLabelSearchFieldItem(title: result["lf"] as! String, subtitle: criteria.uppercased(), image: UIImage(named: "acronym_icon")))
                            }
                            
                            DispatchQueue.main.async {
                                callback(results)
                            }
                        } else {
                            DispatchQueue.main.async {
                                callback([])
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            callback([])
                        }
                    }
                }
                catch {
                    print("Network error: \(error)")
                    DispatchQueue.main.async {
                        callback([])
                    }
                }
            })
            
            task.resume()
        }
    }
    
}

