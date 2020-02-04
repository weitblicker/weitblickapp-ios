//
//  MarkDownImage.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 04.02.20.
//  Copyright © 2020 HS Osnabrueck. All rights reserved.
//

import MarkdownKit

class MarkDownLink : MarkdownElement{
    private static let regex = "(https[^\s]+)"

    override var regex: String {
      return MarkDownLink.regex
    }

    override func match(_ match: NSTextCheckingResult,attributedString: NSMutableAttributedString) {
        let linkName = attributedString.attributedSubstring(from: match.range(at: 3)).string
      let linkURLString = linkName
      formatText(attributedString, range: match.range, link: linkURLString)
      addAttributes(attributedString, range: match.range, link: linkURLString)
    }
}
