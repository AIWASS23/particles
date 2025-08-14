//
//  Policy.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation

enum Policy: Sendable {
    case unlimited
    case fixed(maxActive: Int)
    case adaptive(cpuTarget: Double)
}


