//
//  CloudKitSyncable.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable {
    
    var cloudKitRecordID: CKRecordID? { get set }
}

extension CloudKitSyncable {
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .none)
    }
}

