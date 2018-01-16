//
//  Item.swift
//  Todoey
//
//  Created by Tom Daniel Home on 14/1/18.
//  Copyright © 2018 Thomas Daniel. All rights reserved.
//

import Foundation

//Note you do not have to name your class the same BUT 99% of the time you do.

//Make the call conform to the Encodable so that the data can be saved to extrenal data file.
//To make sure this works - all objects types of the class must be standard.
//This ensures that the dtaa is encodable and decodable.

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
