//
//  Date-Extensions.swift
//  MyTask
//
//  Created by Celestial on 19/02/24.
//

import Foundation
extension Date
{
    func toString() -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
        
//        dateFormater.dateFormat = "mm/dd/yyyy"
        
        let result = dateFormater.string(from: self)
        return result
    }
}
