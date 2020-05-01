//
//  GoogleLocationVC.swift
//  Pickey
//
//  Created by octal on 24/12/19.
//  Copyright © 2019 Sunil Pradhan. All rights reserved.
//

import UIKit
import MapKit

class GoogleLocationVC: UIViewController {
   
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var tableviewSearch: UITableView!
    @IBOutlet weak var searchView: UIView!
    var autocompleteResults :[GApiResponse.Autocomplete] = []
 
    @IBAction func searchButtonPressed(_ sender: Any) {
        textfieldAddress.becomeFirstResponder()
    }
    @IBAction func btnBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    self.tableviewSearch.reloadData()
                }
            } else { print(response.error ?? kError) }
        }
    }
    func hideResults(){
        searchView.isHidden = true
        autocompleteResults.removeAll()
        tableviewSearch.reloadData()
    }
}

extension GoogleLocationVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideResults() ; return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let fullText = text.replacingCharacters(in: range, with: string)
        if fullText.count > 2 {
            showResults(string:fullText)
        }else{
            hideResults()
        }
        return true
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//       // constraintSearchIconWidth.constant = 0.0 ; return true
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//       // constraintSearchIconWidth.constant = 38.0 ; return true
//    }
}
extension GoogleLocationVC : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var input = GInput()
        let destination = GLocation.init(latitude: Strlat, longitude: Strlat)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {

                DispatchQueue.main.async {
                    self.textfieldAddress.text = places.first?.formattedAddress
                    
                }
            } else { print(response.error ?? kError) }
        }
    }
}
extension GoogleLocationVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = autocompleteResults[indexPath.row].formattedAddress
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textfieldAddress.text = autocompleteResults[indexPath.row].formattedAddress
        textfieldAddress.resignFirstResponder()
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = true
                    Strlat = place.latitude!
                    Strlong = place.longitude!
                    StraddressString = place.formattedAddress
                    StrCityName = place.title!
                  
                    let housenumberarr = place.formattedAddress.components(separatedBy: ",")
                    if housenumberarr.count == 1
                    {
                        let houseno = housenumberarr[0]
                        StrHouseNumber = houseno
                        //self.appDelegate.strHouseNumber =  houseno
                    }
                    else{
                    let houseno = housenumberarr[0] + housenumberarr[1]
                         StrHouseNumber = houseno
                        //self.appDelegate.strHouseNumber =  houseno
                    }
                    
                    if let lat = place.latitude, let lng = place.longitude{
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    }
                    self.tableviewSearch.reloadData()
                    
                    NotificationCenter.default.post(name: Notification.Name("SendGoogleLocation"), object: "GoogleLocation")
                     self.navigationController?.popViewController(animated: true)
                    
                }
            } else { print(response.error ?? kError) }
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


