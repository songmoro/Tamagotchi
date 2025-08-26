//
//  LocalizedErrorReason.swift
//  Tamagotchi
//
//  Created by 송재훈 on 8/26/25.
//

import Foundation

struct LocalizedErrorReason: LocalizedError {
    var errorDescription: String?
    init(message: String) { self.errorDescription = message }
}
