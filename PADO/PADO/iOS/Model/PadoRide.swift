//
//  PadoRide.swift
//  PADO
//
//  Created by 황성진 on 2/10/24.
//

import FirebaseFirestore

struct PadoRide: Decodable, Identifiable {
    @DocumentID var id: String?
 
    var imageUrl: String
    var storageFileName: String
    var time: Timestamp
}
