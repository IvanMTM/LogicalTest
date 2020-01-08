// make a function that detect valid brackets

import UIKit

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    
    subscript (range: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        let substring = self[startIndex..<stopIndex]
        return String(substring)
    }
}

enum Bracket {
    enum State {
        case open, close
    }
    
    case a(state: State)
    case b(state: State)
    case c(state: State)
    case d(state: State)
    
    init(char: Character) {
        switch char {
        case "[": self = .a(state: .open)
        case "]": self = .a(state: .close)
        case "<": self = .b(state: .open)
        case ">": self = .b(state: .close)
        case "{": self = .c(state: .open)
        case "}": self = .c(state: .close)
        case "(": self = .d(state: .open)
        case ")": self = .d(state: .close)
        default: fatalError()
        }
    }
    
    var string: String {
        switch self {
        case .a(let state):
            return state == .open ? "[" : "]"
        case .b(let state):
            return state == .open ? "<" : ">"
        case .c(let state):
            return state == .open ? "{" : "}"
        case .d(let state):
            return state == .open ? "(" : ")"
        }
    }
    
    var state: State {
        switch self {
        case .a(let state): return state
        case .b(let state): return state
        case .c(let state): return state
        case .d(let state): return state
        }
    }
    
    var typeIdentifier: Int {
        switch self {
        case .a: return 1
        case .b: return 2
        case .c: return 3
        case .d: return 4
        }
    }
    
    func isSameType(with bracket: Bracket) -> Bool {
        return typeIdentifier == bracket.typeIdentifier
    }
    
    func isSameInState(with bracket: Bracket) -> Bool {
        return state == bracket.state
    }
    
    static func convert(text: String) -> [Bracket] {
        let brackets = text.map { Bracket(char: $0) }
        return brackets
    }
}

func validInput(p: String) -> Bool {
    var bracketContainer = [Bracket]()
    for char in p {
        let bracket = Bracket(char: char)
        switch bracket.state {
        case .open:
            bracketContainer += [bracket]
        case .close:
            if !bracketContainer.isEmpty,
               let index = bracketContainer.lastIndex(
                where: { $0.isSameType(with: bracket) && !$0.isSameInState(with: bracket) }) {
                
                bracketContainer.remove(at: index)
            } else {
                return false
            }
        }
    }
    return bracketContainer.count == 0
}

var inputs = [
    "<][>",
    "<>[]{}()",
    "[]{}()",
    "{<[]>}",
    "({})"
]

let check = inputs.map { validInput(p: $0) }
print(check)

