//
//  ViewController.swift
//  easeXML
//
//  Created by Larry Mcdowell on 8/12/19.
//  Copyright © 2019 Larry Mcdowell. All rights reserved.
//

import UIKit


class Tag {
    var version:String?
    var namespace:String?
}

struct metar {
    var raw_text:String?
    var station_id:String?
    var observation_time:String?
    var latitude:Double?
    var flight_category:String?
}

class ViewController: UIViewController, XMLParserDelegate {
    
    var workingMetar:metar = metar()
    var metarResults:[metar] = [metar]()
    var xml:[Tag] = [Tag]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let FAA_URL:URL = URL(string: "https://www.aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString=KDEN%20KSEA%20PHNL&hoursBeforeNow=2")!
        let parser = XMLParser(contentsOf: FAA_URL)
        parser?.delegate = self
       parser?.parse()
        
    }
    
    var currentElement:String = "begin"
    var currentCharacters:String = ""
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "response" {
            let tempTag = Tag()
            if let version = attributeDict["version"] {
                tempTag.version = version
            }
            if let c = attributeDict["xmlns:xsi"] {
//                if let count = Int(c) {
//                    tempTag.count = count;
//                }
                tempTag.namespace = c
            }
            self.xml.append(tempTag);
           
                print("xml is version \(tempTag.version) for \(tempTag.namespace)")
            
        }
       if elementName == "METAR"
            {
                //print("new metar")
                workingMetar = metar()//clear
        }
        
        if elementName == "raw_text"{
            currentElement = "raw_text"
        }
    }//end func
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
       
            
        if currentElement == "raw_text" {
            currentCharacters += string //may break up pieces of text
        }
        
    }
    func second(){
        //let response =
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "METAR"
        {
            metarResults.append(workingMetar)
           // print(workingMetar)
        }
        if elementName == "raw_text"{
            currentElement = "whoknows"
            workingMetar.raw_text = currentCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentCharacters = ""
           // print(workingMetar.raw_text)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        
        metarResults.forEach {
            print("Metar Entry:\n")
                print($0.raw_text!)
           print("\n")
        }
        
        //print("metar: \(metarResults.last!.raw_text)")
        print("done")
    }
    
   // let raw_data_fx:(String,metar)->(metar)

}

