//
//  RelationshipDetails.swift
//  PBTreeVIew
//
//  Created by Partho Biswas on 3/5/17.
//
//

import Foundation
import ObjectMapper

class RelationshipDetails: Mappable {
    
    var social_security_number: String?
    var name: String?
    var rank: String?
    var referral_code: String?
    var email: String?
    var relation: String?
    var relation_id: String?
    var color_code: String?
    var profile_pic: String?
    
    var ismodified: String?


    var relatives: [RelationshipDetails]?
    
    
    required init?(map: Map) {
        
    }
    
    
    init?() {
        
    }
    
    
    
    public func setRelationshipDetails(ssn: String, name: String, rank: String, referral_code: String?, email: String?, relation: String, relation_id: String?,color_code:String?,ismodified:String?, relatives: [RelationshipDetails]?) {
        self.social_security_number = ssn
        self.name = name
        self.rank = rank
        self.referral_code = referral_code
        self.email = email
        self.relation = relation
        self.relation_id = relation_id
        self.relatives = relatives
        self.color_code = color_code
         self.profile_pic = color_code
         self.ismodified = ismodified
    }

    
    
    // Mappable
    func mapping(map: Map) {
        social_security_number <- map[JSON_Keys.SSN]
        name <- map[JSON_Keys.name]
        rank <- map[JSON_Keys.rank]
        referral_code <- map[JSON_Keys.referral_code]
        email <- map[JSON_Keys.email]
        relation <- map[JSON_Keys.relation_type]
        relation_id <- map[JSON_Keys.relation_id]
        relatives <- map[JSON_Keys.relatives]
        color_code <- map[JSON_Keys.color_code]
        email <- map[JSON_Keys.email]
        profile_pic <- map[JSON_Keys.profile_pic]
        ismodified <- map[JSON_Keys.ismodified]
        
    }
    
}
