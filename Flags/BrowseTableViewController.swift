//
//  BrowseTableViewController.swift
//  Flags
//
//  Created by Benjamin Lopez on 20/01/2017.
//  Copyright © 2017 Scotow. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    static var countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua_and_Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia_and_Herzegovina", "Botswana", "Brazil", "Brunei_Darussalam", "Bulgaria", "Burkina_Faso", "Burundi", "Côte_d'Ivoire", "Cambodia", "Cameroon", "Canada", "Cape_Verde", "Central_African_Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Costa_Rica", "Croatia", "Cuba", "Cyprus", "Czech_Republic", "Democratic_Republic_of_the_Congo", "Denmark", "Djibouti", "Dominica", "Dominican_Republic", "Ecuador", "Egypt", "El_Salvador", "Equatorial_Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea-Bissau", "Guinea", "Guyana", "Haiti", "Holy_See_(Vatican_City_State)", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran,_Islamic_Republic_of", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea,_Democratic_People's_Republic_of", "Korea,_Republic_of", "Kuwait", "Kyrgyzstan", "Lao_People's_Democratic_Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia,_the_Former_Yugoslav_Republic_of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall_Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia,_Federated_States_of", "Moldova,_Republic_of", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New_Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua_New_Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russian_Federation", "Rwanda", "Saint_Kitts_and_Nevis", "Saint_Lucia", "Saint_Vincent_and_the_Grenadines", "Samoa", "San_Marino", "Sao_Tome_and_Principe", "Saudi_Arabia", "Senegal", "Serbia", "Seychelles", "Sierra_Leone", "Singapore", "Slovakia", "Slovenia", "Solomon_Islands", "Somalia", "South_Africa", "Spain", "Sri_Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syrian_Arab_Republic", "Taiwan,_Province_of_China", "Tajikistan", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad_and_Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United_Arab_Emirates", "United_Kingdom", "United_Republic_of_Tanzania", "United_States", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Viet_Nam", "Western_Sahara", "Yemen", "Zambia", "Zimbabwe"]
    
    private var filteredCountries: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        filteredCountries = BrowseTableViewController.countries
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animated {
            animateTable()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath) as? CountryTableViewCell
        
        guard let countryCell = cell else {
            fatalError("Problem creating cell.")
        }

        countryCell.countryName.text = filteredCountries[indexPath.row].replacingOccurrences(of: "_", with: " ")
        countryCell.countryFlag.image = UIImage(named: filteredCountries[indexPath.row])

        return countryCell
    }
    
    // MARK: Search Bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = searchText.isEmpty ? BrowseTableViewController.countries : BrowseTableViewController.countries.filter {
            (country: String) in return country.range(of: searchText, options: .caseInsensitive) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCountries = BrowseTableViewController.countries
        tableView.reloadData()
        
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: Animations
    
    func animateTable() {
        let tableViewHeight = tableView.bounds.size.height
        
        let cells = tableView.visibleCells
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        for (index, cell) in cells.enumerated() {
            UIView.animate(withDuration: 1, delay: Double(index) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "showDetail":
            guard let detailController = segue.destination as? DetailViewController else {
                return
            }
            
            guard let selectedCell = sender as? CountryTableViewCell else {
                return
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                return
            }
            
            let country = filteredCountries[indexPath.row]
            detailController.flag = country
            detailController.title = country.replacingOccurrences(of: "_", with: " ")
            
        default:
            fatalError("Unknow segue identifier.")
        }
    }

}
