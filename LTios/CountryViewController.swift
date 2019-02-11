//
//  CountryViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    var didSetupConstraints = false
    
    var countriesNameArray = [Objects]()
    var countriesCodeArray = [Objects]()
    var alphabeticalIndex = [String]()
    
    let tableView = CountrySelectorTableView()
    let titleLabel = CountrySelectorTitle()
    let closeButton = CountrySelectorCloseButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let sortedNames = countriesName.sorted(by: { $0.0 < $1.0 })
        for (key, value) in sortedNames {
            countriesNameArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        let sortedCode = countriesCode.sorted(by: { $0.0 < $1.0 })
        for (key, value) in sortedCode {
            countriesCodeArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        alphabeticalIndex.removeAll()
        for letter in countriesNameArray {
            alphabeticalIndex.append(letter.sectionName)
        }
        
        tableView.reloadData()
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            closeButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.bottom).multipliedBy(0.05)
                make.leftMargin.equalTo(15)
            }
            
            titleLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.bottom).multipliedBy(0.1)
                make.leftMargin.equalTo(15)
            }
            
            tableView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view)
                make.height.equalTo(view).multipliedBy(0.85).offset(-25)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    @objc func closeView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeCountryView"), object: nil)
    }
    
}

// MARK: Table View Delegate and Datasource
extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesNameArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell"
        var cell: CountryTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? CountryTableViewCell
        
        if cell != nil {
            cell = CountryTableViewCell()
            cell?.selectionStyle = .none
            cell?.backgroundColor = .clear
            
            cell?.countryFlag.image = UIImage(named: countriesCodeArray[indexPath.section].sectionObjects[indexPath.row])
            cell?.countryLabel.text = countriesNameArray[indexPath.section].sectionObjects[indexPath.row]
            
            if countriesCodeArray[indexPath.section].sectionObjects[indexPath.row] == selectedCountry {
                cell?.check.isHidden = false
            } else {
                cell?.check.isHidden = true
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countriesCodeArray[section].sectionName.capitalized
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countriesCodeArray[indexPath.section].sectionObjects[indexPath.row]
        tableView.reloadData()
        closeView()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alphabeticalIndex
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
}
