//
//  SupplementaryViewError.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 17/12/2567 BE.
//

enum SupplementaryViewError: Error, CustomStringConvertible {
    case unexpectedKind(String)
    case dequeuingFailed(kind: String, reuseIdentifier: String)
    case unhandledCustomElement(CustomElement)
    
    var description: String {
        switch self {
        case .unexpectedKind(let kind):
            return "Неожиданный тип дополнительного элемента: \(kind)"
        case .dequeuingFailed(let kind, let reuseIdentifier):
            return "Не удалось извлечь дополнительный элемент типа \(kind) с идентификатором \(reuseIdentifier)"
        case .unhandledCustomElement(let element):
            return "Необработанный пользовательский элемент: \(element)"
        }
    }
}
