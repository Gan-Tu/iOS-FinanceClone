//
//  Currency.swift
//  FinanceClone
//
//  Created by Gan Tu on 10/28/23.
//

import Foundation

enum Currency: String, CaseIterable, Codable {
    case USD = "USD"
    case EUR = "EUR"
    case GBP = "GBP"
    case JPY = "JPY"
    case AUD = "AUD"
    case CAD = "CAD"
    case CHF = "CHF"
    case CNY = "CNY"
    case INR = "INR"
    case BRL = "BRL"
    
    var name: String {
        switch self {
        case .USD: return "US Dollar"
        case .EUR: return "Euro"
        case .GBP: return "British Pound"
        case .JPY: return "Japanese Yen"
        case .AUD: return "Australian Dollar"
        case .CAD: return "Canadian Dollar"
        case .CHF: return "Swiss Franc"
        case .CNY: return "Chinese Yuan"
        case .INR: return "Indian Rupee"
        case .BRL: return "Brazilian Real"
        }
    }
    
    var symbol: String {
        switch self {
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD, .CAD: return "$"
        case .CHF: return "CHF"
        case .CNY: return "¥"
        case .INR: return "₹"
        case .BRL: return "R$"
        }
    }
}
