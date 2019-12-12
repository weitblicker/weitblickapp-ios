//
//  Extensions.swift
//  Weitblick
//
//  Created by Michel Einsweiler on 11.12.19.
//  Copyright © 2019 HS Osnabrueck. All rights reserved.
//

import UIKit

struct Constants{
    static let url  = "https://new.weitblicker.org"
    static let loginURL = "https://new.weitblicker.org/rest/auth/login/"
    static let restURL  = "https://new.weitblicker.org/rest"
    static let mediaURL = "https://new.weitblicker.org/media"
    static let cycleURL = "https://new.weitblicker.org/rest/cycle/segment/"
    static let regex = "!\\[(.*?)\\]\\((.*?)\\\""
    static let regex2 = "" // \[?(!)\[(?<alt>[^\]\[]*\[?[^\]\[]*\]?[^\]\[]*)\]\((?<url>[^\s]+?)(?:\s+(["'])(?<title>.*?)\4)?\)
    static let regexReplace = "!\\[(.*?)\\]\\((.*?)\\)"
    static let rect = CGRect.init(x: 200/2, y: 50/2, width: 400, height: 180)
}

struct FAQEntry{
    let title : String
    let question : String
    let answer : String
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UIImage{
    
    func crop(to:CGSize) -> UIImage {

        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)

        guard let newCgImage = contextImage.cgImage else { return self }

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height

        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height

        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? self
      }
    }

extension Date{
    func dateAndTimetoString(format: String = "dd.MM.yyyy") -> String {
    let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
    return formatter.string(from: self)
        }
}

extension Date{
    func dateAndTimetoStringISO(format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> String {
    let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
    return formatter.string(from: self)
        }
}

extension Date{
    func dateAndTimetoStringUS(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


