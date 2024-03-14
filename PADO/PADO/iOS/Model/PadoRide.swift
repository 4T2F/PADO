//
//  PadoRide.swift
//  PADO
//
//  Created by 황성진 on 2/10/24.
//

import Firebase
import FirebaseFirestoreSwift

import Foundation

struct PadoRide: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
 
    var imageUrl: String
    var storageFileName: String
    var time: Timestamp
}
