//
//  Extensions.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/13/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation

extension URL {
    
    func createVideoURL() -> URL? {
        do {
            let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let finalDirectory = directoryURL.appendingPathComponent(self.path)
            return finalDirectory
        } catch let e {
            print("Error getting docs directory \(e)")
        }
        return nil
    }
}

extension String {
    func createVideoURL() -> URL? {
        do {
            let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let finalDirectory = directoryURL.appendingPathComponent(self)
            return finalDirectory
        } catch let e {
            print("Error getting docs directory \(e)")
        }
        return nil
    }
}
