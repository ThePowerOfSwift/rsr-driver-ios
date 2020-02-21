//
//  AppDelegate.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 05/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
 import SwiftMessages

  class Themes: NSObject {
  static let sharedInstance = Themes()
    let screenSize:CGRect = UIScreen.main.bounds
     var progressView : UIView!
    var success_img : UIImageView!
    var restore_lbl : UILabel!
    var kLanguage : String{
        get {
            return "en"
        }
    }
    var spinner:JHSpinnerView?
        
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }

    let  codename:NSArray=["Afghanistan(+93)", "Albania(+355)","Algeria(+213)","American Samoa(+1684)","Andorra(+376)","Angola(+244)","Anguilla(+1264)","Antarctica(+672)","Antigua and Barbuda(+1268)","Argentina(+54)","Armenia(+374)","Aruba(+297)","Australia(+61)","Austria(+43)","Azerbaijan(+994)","Bahamas(+1242)","Bahrain(+973)","Bangladesh(+880)","Barbados(+1246)","Belarus(+375)","Belgium(+32)","Belize(+501)","Benin(+229)","Bermuda(+1441)","Bhutan(+975)","Bolivia(+591)","Bosnia and Herzegovina(+387)","Botswana(+267)","Brazil(+55)","British Virgin Islands(+1284)","Brunei(+673)","Bulgaria(+359)","Burkina Faso(+226)","Burma (Myanmar)(+95)","Burundi(+257)","Cambodia(+855)","Cameroon(+237)","Canada(+1)","Cape Verde(+238)","Cayman Islands(+1345)","Central African Republic(+236)","Chad(+235)","Chile(+56)","China(+86)","Christmas Island(+61)","Cocos (Keeling) Islands(+61)","Colombia(+57)","Comoros(+269)","Cook Islands(+682)","Costa Rica(+506)","Croatia(+385)","Cuba(+53)","Cyprus(+357)","Czech Republic(+420)","Democratic Republic of the Congo(+243)","Denmark(+45)","Djibouti(+253)","Dominica(+1767)","Dominican Republic(+1809)","Ecuador(+593)","Egypt(+20)","El Salvador(+503)","Equatorial Guinea(+240)","Eritrea(+291)","Estonia(+372)","Ethiopia(+251)","Falkland Islands(+500)","Faroe Islands(+298)","Fiji(+679)","Finland(+358)","France (+33)","French Polynesia(+689)","Gabon(+241)","Gambia(+220)","Gaza Strip(+970)","Georgia(+995)","Germany(+49)","Ghana(+233)","Gibraltar(+350)","Greece(+30)","Greenland(+299)","Grenada(+1473)","Guam(+1671)","Guatemala(+502)","Guinea(+224)","Guinea-Bissau(+245)","Guyana(+592)","Haiti(+509)","Holy See (Vatican City)(+39)","Honduras(+504)","Hong Kong(+852)","Hungary(+36)","Iceland(+354)","India(+91)","Indonesia(+62)","Iran(+98)","Iraq(+964)","Ireland(+353)","Isle of Man(+44)","Israel(+972)","Italy(+39)","Ivory Coast(+225)","Jamaica(+1876)","Japan(+81)","Jordan(+962)","Kazakhstan(+7)","Kenya(+254)","Kiribati(+686)","Kosovo(+381)","Kuwait(+965)","Kyrgyzstan(+996)","Laos(+856)","Latvia(+371)","Lebanon(+961)","Lesotho(+266)","Liberia(+231)","Libya(+218)","Liechtenstein(+423)","Lithuania(+370)","Luxembourg(+352)","Macau(+853)","Macedonia(+389)","Madagascar(+261)","Malawi(+265)","Malaysia(+60)","Maldives(+960)","Mali(+223)","Malta(+356)","MarshallIslands(+692)","Mauritania(+222)","Mauritius(+230)","Mayotte(+262)","Mexico(+52)","Micronesia(+691)","Moldova(+373)","Monaco(+377)","Mongolia(+976)","Montenegro(+382)","Montserrat(+1664)","Morocco(+212)","Mozambique(+258)","Namibia(+264)","Nauru(+674)","Nepal(+977)","Netherlands(+31)","Netherlands Antilles(+599)","New Caledonia(+687)","New Zealand(+64)","Nicaragua(+505)","Niger(+227)","Nigeria(+234)","Niue(+683)","Norfolk Island(+672)","North Korea (+850)","Northern Mariana Islands(+1670)","Norway(+47)","Oman(+968)","Pakistan(+92)","Palau(+680)","Panama(+507)","Papua New Guinea(+675)","Paraguay(+595)","Peru(+51)","Philippines(+63)","Pitcairn Islands(+870)","Poland(+48)","Portugal(+351)","Puerto Rico(+1)","Qatar(+974)","Republic of the Congo(+242)","Romania(+40)","Russia(+7)","Rwanda(+250)","Saint Barthelemy(+590)","Saint Helena(+290)","Saint Kitts and Nevis(+1869)","Saint Lucia(+1758)","Saint Martin(+1599)","Saint Pierre and Miquelon(+508)","Saint Vincent and the Grenadines(+1784)","Samoa(+685)","San Marino(+378)","Sao Tome and Principe(+239)","Saudi Arabia(+966)","Senegal(+221)","Serbia(+381)","Seychelles(+248)","Sierra Leone(+232)","Singapore(+65)","Slovakia(+421)","Slovenia(+386)","Solomon Islands(+677)","Somalia(+252)","South Africa(+27)","South Korea(+82)","Spain(+34)","Sri Lanka(+94)","Sudan(+249)","Suriname(+597)","Swaziland(+268)","Sweden(+46)","Switzerland(+41)","Syria(+963)","Taiwan(+886)","Tajikistan(+992)","Tanzania(+255)","Thailand(+66)","Timor-Leste(+670)","Togo(+228)","Tokelau(+690)","Tonga(+676)","Trinidad and Tobago(+1868)","Tunisia(+216)","Turkey(+90)","Turkmenistan(+993)","Turks and Caicos Islands(+1649)","Tuvalu(+688)","Uganda(+256)","Ukraine(+380)","United Arab Emirates(+971)","United Kingdom(+44)","United States(+1)","Uruguay(+598)","US Virgin Islands(+1340)","Uzbekistan(+998)","Vanuatu(+678)","Venezuela(+58)","Vietnam(+84)","Wallis and Futuna(+681)","West Bank(970)","Yemen(+967)","Zambia(+260)","Zimbabwe(+263)"];
    let code:NSArray=["+93", "+355","+213","+1684","+376","+244","+1264","+672","+1268","+54","+374","+297","+61","+43","+994","+1242","+973","+880","+1246","+375","+32","+501","+229","+1441","+975","+591"," +387","+267","+55","+1284","+673","+359","+226","+95","+257","+855","+237","+1","+238","+1345","+236","+235","+56","+86","+61","+61","+57","+269","+682","+506","+385","+53","+357","+420","+243","+45","+253","+1767","+1809","+593","+20","+503","+240","+291","+372","+251"," +500","+298","+679","+358","+33","+689","+241","+220"," +970","+995","+49","+233","+350","+30","+299","+1473","+1671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+39","+225","+1876","+81","+962","+7","+254","+686","+381","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1670","+47","+968","+92","+680","+507","+675","+595","+51","+63","+870","+48","+351","+1","+974","+242","+40","+7","+250","+590","+290","+1869","+1758","+1599","+508","+1784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+82","+34","+94","+249","+597","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1868","+216","+90","+993","+1649","+688","+256","+380","+971","+44","+1","+598","+1340","+998","+678","+58","+84","+681","+970","+967","+260","+263"];
    
    
    
    var osVersion:String{
        let systemVersion = UIDevice.current.systemVersion
        return systemVersion
    }
    func showErrorpopup(Msg: String)
    {
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.error)
        success.configureDropShadow()
        success.configureContent(title: Themes.sharedInstance.GetAppname(), body: Msg)
          success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    func ShowAlert(title:String,body:String,isSuccess:Bool)
    {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        var image:UIImage = #imageLiteral(resourceName: "info")
        if(isSuccess)
        {
        image = #imageLiteral(resourceName: "tick-1")
        }

        messageView.configureContent(title: title, body: body, iconImage: image, iconText: "", buttonImage: nil, buttonTitle: "Ok") { _ in
            SwiftMessages.hide()
        }
        
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: messageView)

    }
    
    func saveSign(user_id:String)
    {
        UserDefaults.standard.set(user_id, forKey: "sign")
        UserDefaults.standard.synchronize()
    }
    func returnSign()->String
    {
        var currency : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "sign"))
        if(currency == ""  || currency == nil)
        {
            currency = ""
        }
        return currency!
    }

    func shownotificationBanner(Msg: String )
    {
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.info)
        success.configureContent(title: Themes.sharedInstance.GetAppname(), body: Msg)
        // success.configureContent(title: Msg, body: "")
        success.button?.isHidden = true
        success.buttonTapHandler = { _ in SwiftMessages.hide() }
        // Hide when message view tapped
        success.tapHandler = { _ in SwiftMessages.hide() }
         var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
     }
    
    func RemoveNonnumericEntitites(PassedValue:NSString)->String
    {
        let stringArray = PassedValue.components(
            separatedBy: NSCharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        return newString

    }
    
    var deviceID:AnyObject{
        let uuid = UIDevice.current.identifierForVendor?.uuid
        return uuid as AnyObject
    }
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":           return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    func getCountryList() -> (NSDictionary) {
        let dict = [
            "AF" : ["Afghanistan", "93"],
            "AX" : ["Aland Islands", "358"],
            "AL" : ["Albania", "355"],
            "DZ" : ["Algeria", "213"],
            "AS" : ["American Samoa", "1"],
            "AD" : ["Andorra", "376"],
            "AO" : ["Angola", "244"],
            "AI" : ["Anguilla", "1"],
            "AQ" : ["Antarctica", "672"],
            "AG" : ["Antigua and Barbuda", "1"],
            "AR" : ["Argentina", "54"],
            "AM" : ["Armenia", "374"],
            "AW" : ["Aruba", "297"],
            "AU" : ["Australia", "61"],
            "AT" : ["Austria", "43"],
            "AZ" : ["Azerbaijan", "994"],
            "BS" : ["Bahamas", "1"],
            "BH" : ["Bahrain", "973"],
            "BD" : ["Bangladesh", "880"],
            "BB" : ["Barbados", "1"],
            "BY" : ["Belarus", "375"],
            "BE" : ["Belgium", "32"],
            "BZ" : ["Belize", "501"],
            "BJ" : ["Benin", "229"],
            "BM" : ["Bermuda", "1"],
            "BT" : ["Bhutan", "975"],
            "BO" : ["Bolivia", "591"],
            "BA" : ["Bosnia and Herzegovina", "387"],
            "BW" : ["Botswana", "267"],
            "BV" : ["Bouvet Island", "47"],
            "BQ" : ["BQ", "599"],
            "BR" : ["Brazil", "55"],
            "IO" : ["British Indian Ocean Territory", "246"],
            "VG" : ["British Virgin Islands", "1"],
            "BN" : ["Brunei Darussalam", "673"],
            "BG" : ["Bulgaria", "359"],
            "BF" : ["Burkina Faso", "226"],
            "BI" : ["Burundi", "257"],
            "KH" : ["Cambodia", "855"],
            "CM" : ["Cameroon", "237"],
            "CA" : ["Canada", "1"],
            "CV" : ["Cape Verde", "238"],
            "KY" : ["Cayman Islands", "345"],
            "CF" : ["Central African Republic", "236"],
            "TD" : ["Chad", "235"],
            "CL" : ["Chile", "56"],
            "CN" : ["China", "86"],
            "CX" : ["Christmas Island", "61"],
            "CC" : ["Cocos (Keeling) Islands", "61"],
            "CO" : ["Colombia", "57"],
            "KM" : ["Comoros", "269"],
            "CG" : ["Congo (Brazzaville)", "242"],
            "CD" : ["Congo, Democratic Republic of the", "243"],
            "CK" : ["Cook Islands", "682"],
            "CR" : ["Costa Rica", "506"],
            "CI" : ["Côte d'Ivoire", "225"],
            "HR" : ["Croatia", "385"],
            "CU" : ["Cuba", "53"],
            "CW" : ["Curacao", "599"],
            "CY" : ["Cyprus", "537"],
            "CZ" : ["Czech Republic", "420"],
            "DK" : ["Denmark", "45"],
            "DJ" : ["Djibouti", "253"],
            "DM" : ["Dominica", "1"],
            "DO" : ["Dominican Republic", "1"],
            "EC" : ["Ecuador", "593"],
            "EG" : ["Egypt", "20"],
            "SV" : ["El Salvador", "503"],
            "GQ" : ["Equatorial Guinea", "240"],
            "ER" : ["Eritrea", "291"],
            "EE" : ["Estonia", "372"],
            "ET" : ["Ethiopia", "251"],
            "FK" : ["Falkland Islands (Malvinas)", "500"],
            "FO" : ["Faroe Islands", "298"],
            "FJ" : ["Fiji", "679"],
            "FI" : ["Finland", "358"],
            "FR" : ["France", "33"],
            "GF" : ["French Guiana", "594"],
            "PF" : ["French Polynesia", "689"],
            "TF" : ["French Southern Territories", "689"],
            "GA" : ["Gabon", "241"],
            "GM" : ["Gambia", "220"],
            "GE" : ["Georgia", "995"],
            "DE" : ["Germany", "49"],
            "GH" : ["Ghana", "233"],
            "GI" : ["Gibraltar", "350"],
            "GR" : ["Greece", "30"],
            "GL" : ["Greenland", "299"],
            "GD" : ["Grenada", "1"],
            "GP" : ["Guadeloupe", "590"],
            "GU" : ["Guam", "1"],
            "GT" : ["Guatemala", "502"],
            "GG" : ["Guernsey", "44"],
            "GN" : ["Guinea", "224"],
            "GW" : ["Guinea-Bissau", "245"],
            "GY" : ["Guyana", "595"],
            "HT" : ["Haiti", "509"],
            "VA" : ["Holy See (Vatican City State)", "379"],
            "HN" : ["Honduras", "504"],
            "HK" : ["Hong Kong, Special Administrative Region of China", "852"],
            "HU" : ["Hungary", "36"],
            "IS" : ["Iceland", "354"],
            "IN" : ["India", "91"],
            "ID" : ["Indonesia", "62"],
            "IR" : ["Iran, Islamic Republic of", "98"],
            "IQ" : ["Iraq", "964"],
            "IE" : ["Ireland", "353"],
            "IM" : ["Isle of Man", "44"],
            "IL" : ["Israel", "972"],
            "IT" : ["Italy", "39"],
            "JM" : ["Jamaica", "1"],
            "JP" : ["Japan", "81"],
            "JE" : ["Jersey", "44"],
            "JO" : ["Jordan", "962"],
            "KZ" : ["Kazakhstan", "77"],
            "KE" : ["Kenya", "254"],
            "KI" : ["Kiribati", "686"],
            "KP" : ["Korea, Democratic People's Republic of", "850"],
            "KR" : ["Korea, Republic of", "82"],
            "KW" : ["Kuwait", "965"],
            "KG" : ["Kyrgyzstan", "996"],
            "LA" : ["Lao PDR", "856"],
            "LV" : ["Latvia", "371"],
            "LB" : ["Lebanon", "961"],
            "LS" : ["Lesotho", "266"],
            "LR" : ["Liberia", "231"],
            "LY" : ["Libya", "218"],
            "LI" : ["Liechtenstein", "423"],
            "LT" : ["Lithuania", "370"],
            "LU" : ["Luxembourg", "352"],
            "MO" : ["Macao, Special Administrative Region of China", "853"],
            "MK" : ["Macedonia, Republic of", "389"],
            "MG" : ["Madagascar", "261"],
            "MW" : ["Malawi", "265"],
            "MY" : ["Malaysia", "60"],
            "MV" : ["Maldives", "960"],
            "ML" : ["Mali", "223"],
            "MT" : ["Malta", "356"],
            "MH" : ["Marshall Islands", "692"],
            "MQ" : ["Martinique", "596"],
            "MR" : ["Mauritania", "222"],
            "MU" : ["Mauritius", "230"],
            "YT" : ["Mayotte", "262"],
            "MX" : ["Mexico", "52"],
            "FM" : ["Micronesia, Federated States of", "691"],
            "MD" : ["Moldova", "373"],
            "MC" : ["Monaco", "377"],
            "MN" : ["Mongolia", "976"],
            "ME" : ["Montenegro", "382"],
            "MS" : ["Montserrat", "1"],
            "MA" : ["Morocco", "212"],
            "MZ" : ["Mozambique", "258"],
            "MM" : ["Myanmar", "95"],
            "NA" : ["Namibia", "264"],
            "NR" : ["Nauru", "674"],
            "NP" : ["Nepal", "977"],
            "NL" : ["Netherlands", "31"],
            "AN" : ["Netherlands Antilles", "599"],
            "NC" : ["New Caledonia", "687"],
            "NZ" : ["New Zealand", "64"],
            "NI" : ["Nicaragua", "505"],
            "NE" : ["Niger", "227"],
            "NG" : ["Nigeria", "234"],
            "NU" : ["Niue", "683"],
            "NF" : ["Norfolk Island", "672"],
            "MP" : ["Northern Mariana Islands", "1"],
            "NO" : ["Norway", "47"],
            "OM" : ["Oman", "968"],
            "PK" : ["Pakistan", "92"],
            "PW" : ["Palau", "680"],
            "PS" : ["Palestinian Territory, Occupied", "970"],
            "PA" : ["Panama", "507"],
            "PG" : ["Papua New Guinea", "675"],
            "PY" : ["Paraguay", "595"],
            "PE" : ["Peru", "51"],
            "PH" : ["Philippines", "63"],
            "PN" : ["Pitcairn", "872"],
            "PL" : ["Poland", "48"],
            "PT" : ["Portugal", "351"],
            "PR" : ["Puerto Rico", "1"],
            "QA" : ["Qatar", "974"],
            "RE" : ["Réunion", "262"],
            "RO" : ["Romania", "40"],
            "RU" : ["Russian Federation", "7"],
            "RW" : ["Rwanda", "250"],
            "SH" : ["Saint Helena", "290"],
            "KN" : ["Saint Kitts and Nevis", "1"],
            "LC" : ["Saint Lucia", "1"],
            "PM" : ["Saint Pierre and Miquelon", "508"],
            "VC" : ["Saint Vincent and Grenadines", "1"],
            "BL" : ["Saint-Barthélemy", "590"],
            "MF" : ["Saint-Martin (French part)", "590"],
            "WS" : ["Samoa", "685"],
            "SM" : ["San Marino", "378"],
            "ST" : ["Sao Tome and Principe", "239"],
            "SA" : ["Saudi Arabia", "966"],
            "SN" : ["Senegal", "221"],
            "RS" : ["Serbia", "381"],
            "SC" : ["Seychelles", "248"],
            "SL" : ["Sierra Leone", "232"],
            "SG" : ["Singapore", "65"],
            "SX" : ["Sint Maarten", "1"],
            "SK" : ["Slovakia", "421"],
            "SI" : ["Slovenia", "386"],
            "SB" : ["Solomon Islands", "677"],
            "SO" : ["Somalia", "252"],
            "ZA" : ["South Africa", "27"],
            "GS" : ["South Georgia and the South Sandwich Islands", "500"],
            "SS​" : ["South Sudan", "211"],
            "ES" : ["Spain", "34"],
            "LK" : ["Sri Lanka", "94"],
            "SD" : ["Sudan", "249"],
            "SR" : ["Suriname", "597"],
            "SJ" : ["Svalbard and Jan Mayen Islands", "47"],
            "SZ" : ["Swaziland", "268"],
            "SE" : ["Sweden", "46"],
            "CH" : ["Switzerland", "41"],
            "SY" : ["Syrian Arab Republic (Syria)", "963"],
            "TW" : ["Taiwan, Republic of China", "886"],
            "TJ" : ["Tajikistan", "992"],
            "TZ" : ["Tanzania, United Republic of", "255"],
            "TH" : ["Thailand", "66"],
            "TL" : ["Timor-Leste", "670"],
            "TG" : ["Togo", "228"],
            "TK" : ["Tokelau", "690"],
            "TO" : ["Tonga", "676"],
            "TT" : ["Trinidad and Tobago", "1"],
            "TN" : ["Tunisia", "216"],
            "TR" : ["Turkey", "90"],
            "TM" : ["Turkmenistan", "993"],
            "TC" : ["Turks and Caicos Islands", "1"],
            "TV" : ["Tuvalu", "688"],
            "UG" : ["Uganda", "256"],
            "UA" : ["Ukraine", "380"],
            "AE" : ["United Arab Emirates", "971"],
            "GB" : ["United Kingdom", "44"],
            "US" : ["United States of America", "1"],
            "UY" : ["Uruguay", "598"],
            "UZ" : ["Uzbekistan", "998"],
            "VU" : ["Vanuatu", "678"],
            "VE" : ["Venezuela (Bolivarian Republic of)", "58"],
            "VN" : ["Viet Nam", "84"],
            "VI" : ["Virgin Islands, US", "1"],
            "WF" : ["Wallis and Futuna Islands", "681"],
            "EH" : ["Western Sahara", "212"],
            "YE" : ["Yemen", "967"],
            "ZM" : ["Zambia", "260"],
            "ZW" : ["Zimbabwe", "263"]
        ]
        
        return dict as (NSDictionary)
    }
    
    func isUpdateAvailable(completion: @escaping (String?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func StrtoDate(str:String,dateFormat:String,timeformat:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //Your date format
        if(timeformat != "")
        {
        dateFormatter.timeZone = TimeZone(abbreviation: timeformat) //Current time zone
        }
        else
        {
            dateFormatter.timeStyle = .medium //Set time style
            dateFormatter.dateStyle = .medium //Set date style

        }
        let date = dateFormatter.date(from: str) //according to date format your date string
        print(timeformat)
        print(str)

        print(date)
        return date!
     }
    func ReturnAttributedText(color:UIColor,mainText:String,attributeText:String)->NSMutableAttributedString
    {
         let range = (mainText as NSString).range(of: attributeText)
        let attributedString = NSMutableAttributedString(string:mainText)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    func ReturnFontAttributedText(mainText:String,attributeText:String,size:CGFloat)->NSMutableAttributedString
    {
        let range = (mainText as NSString).range(of: attributeText)
        let attributedString = NSMutableAttributedString(string:mainText)
        attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Constant.sharedinstance.Bold, size: size) as Any, range: range)
        return attributedString
    }
    var current_Time:String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let  DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        print(DateInFormat)
        return DateInFormat
    }
    func alertView(title:NSString,Message:NSString,ButtonTitle:NSString)
    {
        
        
    }
    
    func savePaypalid(user_id:String)
    {
        
        UserDefaults.standard.set(user_id, forKey: "amb_paypal_id")
        UserDefaults.standard.synchronize()
    }
    
    func SavemessageCount(user_id:String)
    {
        
        UserDefaults.standard.set(user_id, forKey: "message_count")
        UserDefaults.standard.synchronize()
    }
    
    func GetpaypalID()->String
    {
        var user_id : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "amb_paypal_id"))
        if(user_id == ""  || user_id == nil)
        {
            user_id = ""
        }
        return user_id!
        
    }
    

    func GetmessageCount()->String
    {
        var user_id : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "message_count"))
        if(user_id == ""  || user_id == nil)
        {
            user_id = ""
        }
        return user_id!
        
    }
   
     func saveDeviceToken(DeviceToken:String)
    {
        
        UserDefaults.standard.set(DeviceToken, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    func Saveuser_id(user_id:String)
    {
        
        UserDefaults.standard.set(user_id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    
    func SaveReservationStatus(user_id:String)
    {
        
        UserDefaults.standard.set(user_id, forKey: "active_reservation")
        UserDefaults.standard.synchronize()
    }
    func Savecurrency(str:String)
    {
        
        UserDefaults.standard.set(str, forKey: "currency")
        UserDefaults.standard.synchronize()
    }
    func Saveemail(str:String)
    {
        
        UserDefaults.standard.set(str, forKey: "email")
        UserDefaults.standard.synchronize()
    }
    func Saveemail_verified(str:String)
    {
        
        UserDefaults.standard.set(str, forKey: "email_verified")
        UserDefaults.standard.synchronize()
    }
    
    func Savephone_verified(str:String)
    {
        
        UserDefaults.standard.set(str, forKey: "phone_verified")
        UserDefaults.standard.synchronize()
    }

    func Saveprofile_pic(str:String)
    {
        
        UserDefaults.standard.set(str, forKey: "profile_pic")
        UserDefaults.standard.synchronize()
    }
  
     func Saveverified(str:String)
    {
        UserDefaults.standard.set(str, forKey: "verified")
        UserDefaults.standard.synchronize()
    }
    func SavePhone(str:String)
    {
        UserDefaults.standard.set(str, forKey: "phone")
        UserDefaults.standard.synchronize()
    }
     func Savecountry(str:String)
    {
        UserDefaults.standard.set(str, forKey: "country")
        UserDefaults.standard.synchronize()
    }
    
    func GetPhone()->String
    {
        var currency : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "phone"))
        if(currency == ""  || currency == nil)
        {
            currency = ""
        }
        return currency!
     }
    
    func Getcountry()->String
    {
        var currency : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "country"))
        if(currency == ""  || currency == nil)
        {
            currency = ""
        }
        return currency!
     }
    
    func Getactive_reservation()->String
    {
        var currency : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "active_reservation"))
        if(currency == ""  || currency == nil)
        {
            currency = ""
        }
        return currency!
        
    }
    
    
    func Getcurrency()->String
    {
        var currency : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "currency"))
        if(currency == ""  || currency == nil)
        {
            currency = ""
        }
        return currency!
        
    }
    
    
    func Getemail()->String
    {
        var email : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "email"))
        if(email == ""  || email == nil)
        {
            email = ""
        }
        return email!
        
    }
    func Getphone_verified()->String
    {
        var phone_verified : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "phone_verified"))
        if(phone_verified == ""  || phone_verified == nil)
        {
            phone_verified = ""
        }
        return phone_verified!
        
    }

     func Getemail_verified()->String
    {
        var email_verified : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "email_verified"))
        if(email_verified == ""  || email_verified == nil)
        {
            email_verified = ""
        }
        return email_verified!
        
    }
    func Getprofile_pic()->String
    {
        var profile_pic : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "profile_pic"))
        if(profile_pic == ""  || profile_pic == nil)
        {
            profile_pic = ""
        }
        return profile_pic!
        
    }
    func Getverified()->String
    {
        var verified : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "verified"))
        if(verified == ""  || verified == nil)
        {
            verified = ""
        }
        return verified!
        
    }
    func GetuserID()->String
    {
        var user_id : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "user_id"))
        if(user_id == ""  || user_id == nil)
        {
            user_id = ""
        }
        return user_id!
 
    }
    func CheckLogin()->Bool
    {
        var user_id : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "user_id"))
        if(user_id == ""  || user_id == nil)
        {
            return false

         }
        return true
     }

    
    
    func saveCallToken(DeviceToken:String)
    {
        
        UserDefaults.standard.set(DeviceToken, forKey: "call_token")
        UserDefaults.standard.synchronize()
    }
    func saveServerTime(DeviceToken:String)
    {
        
        UserDefaults.standard.set(DeviceToken, forKey: "serverTime")
        UserDefaults.standard.synchronize()
    }
    func getServerTime() -> String
    {
        var servertime : String? =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "serverTime"))
        if(servertime == ""  || servertime == nil)
        {
            servertime = ""
        }
       return servertime!
    }
    

    
    func getDeviceToken() -> String
    {
        var token : String =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "device_token"))
        if(token == "")
        {
            token = "21a6d650d0063c66fca06e0dc5426d23a3a823be5ac8af13f004e9e415085a7a"
        }
        
        return token
    }
    
    func getCallToken() -> String
    {
        var token : String =  self.CheckNullvalue(Passed_value: UserDefaults.standard.value(forKey: "call_token"))
        if(token == "")
        {
            token = "21a6d650d0063c66fca06e0dc5426d23a3a823be5ac8af13f004e9e415085a7a"
        }
        
        return token
    }
    func ClearuserDetails()
    {
        Themes.sharedInstance.savePaypalid(user_id: "")
        Themes.sharedInstance.Saveuser_id(user_id: "")
        Themes.sharedInstance.Savecurrency(str: "")
        Themes.sharedInstance.Saveemail(str: "")
        Themes.sharedInstance.Saveemail_verified(str: "")
        Themes.sharedInstance.Saveprofile_pic(str: "")
        Themes.sharedInstance.Saveverified(str: "")
        Themes.sharedInstance.SavemessageCount(user_id: "")
        Themes.sharedInstance.SaveReservationStatus(user_id: "")

    }

     func transformedValue(_ value: String) -> Any {
        var convertedValue = Double(value)
        var multiplyFactor: Int = 0
        let tokens: [Any] = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while convertedValue! > Double(1024)
        {
            convertedValue = convertedValue!/Double(1024)
            convertedValue = round(convertedValue!)
            multiplyFactor += 1
        }
        return String(format:"%4.2f %@",convertedValue!, tokens[multiplyFactor] as! String)
    }
     func jssAlertView(viewController:UIViewController,title:String,text:String,buttonTxt:String,color:UIColor){
        
         //  return alertView
    }
    func activityView(View:UIView){
        let attributedString = NSMutableAttributedString(string:"")
        spinner  = JHSpinnerView.showOnView(View, spinnerColor:UIColor.red, overlay:.roundedSquare, overlayColor:UIColor.white.withAlphaComponent(1.0), attributedText: attributedString)
      View.addSubview(spinner!)
          // Add it as a subview
    }
    
    func returnThemeColor()->UIColor
    {
        return UIColor(red:0.03, green:0.73, blue:0.78, alpha:1.0)
        

    }
     func RemoveactivityView(View:UIView)
    {
        spinner?.dismiss()
        spinner?.removeFromSuperview()
        spinner = nil
     }
    
    func AddTopBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        let border:CALayer = CALayer()
        border.backgroundColor = color.cgColor;
         border.frame = CGRect(x: 0, y: 0, width: View.frame.size.width, height: width)
        View.layer.addSublayer(border)
        
    }
    func AddBottomBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        let border:CALayer = CALayer()
        border.backgroundColor = color.cgColor;
        border.frame = CGRect(x: 0, y: View.frame.size.height - width, width: View.frame.size.width, height: width)
        View.layer.addSublayer(border)
        
    }
    func AddTwoBorder(View:UIView,color:UIColor,width:CGFloat)
    {
        
        let topborder:CALayer = CALayer()
        topborder.backgroundColor = color.cgColor;
        topborder.frame = CGRect(x: 0, y: 0, width: View.frame.size.width, height: width)
        let bottomborder:CALayer = CALayer()
        bottomborder.backgroundColor = color.cgColor;
        bottomborder.frame = CGRect(x: 0, y: View.frame.size.height - width, width: View.frame.size.width, height: width)
        View.layer.addSublayer(topborder)
        View.layer.addSublayer(bottomborder)

         
    }
    func isValidPhNo(value: String) -> Bool {
        let num = "[0-9]{10}$";
        let test = NSPredicate(format: "SELF MATCHES %@", num)
        let result =  test.evaluate(with: value)
        return result
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    func saveLanguage( str:NSString) {
        var str = str
        if(str.isEqual(to: "ta"))      {
            str="ta"
        }
        if(str.isEqual(to: "en")) {
            str="en"
        }
        UserDefaults.standard.set(str, forKey: "LanguageName")
        UserDefaults.standard.synchronize()
    }
    func SetLanguageToApp(){
        let savedLang=UserDefaults.standard.object(forKey: "LanguageName") as! NSString
        if(savedLang == "ta") {
            Languagehandler.sharedInstance.setApplicationLanguage(language: Languagehandler.sharedInstance.TamilLanguageShortName)
        }
        if(savedLang == "en"){
            
            Languagehandler.sharedInstance.setApplicationLanguage(language: Languagehandler.sharedInstance.EnglishUSLanguageShortName)
        }
    }
    func setLang(title:String) -> String{
        
        return Languagehandler.sharedInstance.VJLocalizedString(key:title , comment: nil)
        
    }
    func CheckNullvalue(Passed_value:Any?) -> String {
         var Param:Any?=Passed_value
        if(Param == nil || Param is NSNull)
        {
            Param=""
        }
        else
        {
            Param = String(describing: Passed_value!)
        }
         return Param as! String
     }
    
 
    func colorWithHexString (hex:String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    func convertDateFormater(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM-dd-yyyy"
        return  dateFormatter.string(from: date)
        
    }
  
    func saveCounrtyphone(countrycode: String) {
        UserDefaults.standard.set(countrycode, forKey: "countryphone")
        UserDefaults.standard.synchronize()
    }
    func ShowNotification(title:String,subtitle:String)
    {
     }
    func convertImageToBase64(imageData: Data) -> String {
        let base64String = imageData.base64EncodedString()
        
        return base64String
    }

    func GetAppname()->String
    {
        let appname:String=self.CheckNullvalue(Passed_value: Bundle.main.infoDictionary!["CFBundleName"])
        return appname
    
    }
    
    func compressTo(_ expectedSizeInMb:Int, _ image : UIImage) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(image, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return self.resizeImage(image: UIImage(data: data)!)
            }
        }
        return nil
    }
    
    func resizeImage(image: UIImage) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = (actualHeight >= actualWidth) ? Float(UIScreen.main.bounds.size.height) : Float(UIScreen.main.bounds.size.width)
        let maxWidth: Float = (actualHeight >= actualWidth) ? Float(UIScreen.main.bounds.size.width) : Float(UIScreen.main.bounds.size.height)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
    }
 }

extension String {
    
    func slice(from: String, to: String) -> String? {
         return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    var encoded: Any {
        let data : NSData =  self.data(using: String.Encoding.isoLatin1)! as NSData
        let str = String(data: data as Data, encoding: String.Encoding.utf8)!
        print(str)
        return str
    }
    var decoded: String {
        let data : NSData = self.data(using: String.Encoding.utf8)! as NSData
        let str = String(data: data as Data, encoding: String.Encoding.isoLatin1)!
        print(str)
        return str
    }
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[(start ..< end)])
    }
}

extension Date {
    var ticks: UInt64
    {
        return currentTimeInMiliseconds()
    }
    //Date to milliseconds
    func currentTimeInMiliseconds() -> UInt64 {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return UInt64(since1970 * 1000)
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x:0, y:0, width:self.frame.height, height:thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:UIScreen.main.bounds.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    
   
}

extension UINavigationController
{
    func pushViewController(withFlip controller: UIViewController, animated : Bool) {
        self.addPushAnimation(controller: controller, animated: animated)
    }
    func popViewControllerWithFlip(animated : Bool) {
        self.addPopAnimation(animated: animated)
    }
    
    func poptoViewControllerWithFlip(controller : UIViewController, animated : Bool) {
        self.addPopToViewAnimation(controller: controller, animated: animated)
    }
    
    func perfromSegueWithFlip(controller : UIViewController, animated : Bool)
    {
        self.addPushAnimation(controller: controller, animated: animated)
    }
    
    func addPushAnimation(controller : UIViewController, animated : Bool)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromBottom;
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(controller, animated: animated)
    }
    
    func addPopAnimation(animated : Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.layer.add(transition, forKey:kCATransition)
        self.popViewController(animated: animated)
    }
    
   

    
    func addPopToViewAnimation(controller : UIViewController, animated : Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.layer.add(transition, forKey:kCATransition)
        self.popToViewController(controller, animated: animated)
    }
}


extension UIView {
     /**
     Rotate a view by specified degrees
    - parameter angle: angle in degrees
     */
    func rotate(angle angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(M_PI)
        let rotation = CGAffineTransform(rotationAngle: radians)
        self.transform = rotation
    }
 }
extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }

}





