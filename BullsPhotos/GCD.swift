//
//  GCD.swift
//  BullsPhotos
//
//  Created by Matthew Ramsden on 2/24/17.
//  Copyright © 2017 Matthew Ramsden. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
