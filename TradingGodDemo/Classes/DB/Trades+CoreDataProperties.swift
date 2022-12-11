//
//  Trades+CoreDataProperties.swift
//  
//
//  Created by 尹东博 on 2022/12/10.
//
//

import Foundation
import CoreData


extension Trades {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trades> {
        return NSFetchRequest<Trades>(entityName: "Trades")
    }

    @NSManaged public var instId: String?
    @NSManaged public var px: String?
    @NSManaged public var side: String?
    @NSManaged public var sz: String?
    @NSManaged public var tradeId: String?
    @NSManaged public var ts: String?

}
