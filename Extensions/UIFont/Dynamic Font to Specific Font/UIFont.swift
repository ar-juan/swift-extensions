//
//  UIFont.swift
//
//  Created by Arjan van der Laan on 02/02/16.
//

import UIKit

extension UIFont {
    static func IsKnownTextStyle(_ style: String?) -> Bool {
        guard style != nil else {
            return false
        }
        
        var knownTextStyles: [String] =
            [UIFont.TextStyle.body.rawValue,
             UIFont.TextStyle.headline.rawValue,
             UIFont.TextStyle.subheadline.rawValue,
             UIFont.TextStyle.caption1.rawValue,
             UIFont.TextStyle.caption2.rawValue,
             UIFont.TextStyle.footnote.rawValue]
        
        if #available(iOS 9.0, *) {
            let addition: [String] = [UIFont.TextStyle.callout.rawValue,
                                      UIFont.TextStyle.title1.rawValue,
                                      UIFont.TextStyle.title2.rawValue,
                                      UIFont.TextStyle.title3.rawValue]
            knownTextStyles += addition
        }
        
        return knownTextStyles.contains(style!)
    }
    
    func appFontOfSameStyleAndSize() -> UIFont {
        if self.styleAttribute == nil {
            print("appFontOfSameStyleAndSize(): shouldnt come here")
        }
        if UIFont.IsKnownTextStyle(self.styleAttribute) {
            return UIFont.AppFont.FromTextStyle(self.styleAttribute!, fontSize: nil)
        } else {
            return UIFont.AppFont.FromTextStyle(self.styleAttribute ?? "CTFontRegularUsage", fontSize: pointSize)
        }
    }
    
    
    internal struct AppFont {
        // developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html#//apple_ref/doc/uid/TP40009542-CH4-SW65
        static let name = Globals.AppFontFamily /* e.g. "Georgia" */
        static let Body = AppFont.FromTextStyle(UIFont.TextStyle.body.rawValue)
        static let Headline = AppFont.FromTextStyle(UIFont.TextStyle.headline.rawValue)
        static let SubHeadline = AppFont.FromTextStyle(UIFont.TextStyle.subheadline.rawValue)
        static let Caption1 = AppFont.FromTextStyle(UIFont.TextStyle.caption1.rawValue)
        static let Caption2 = AppFont.FromTextStyle(UIFont.TextStyle.caption2.rawValue)
        static let Footnote = AppFont.FromTextStyle(UIFont.TextStyle.footnote.rawValue)
        
        @available(iOS 9.0, *)static let Callout = AppFont.FromTextStyle(UIFont.TextStyle.callout.rawValue)
        @available(iOS 9.0, *) static let Title1 = AppFont.FromTextStyle(UIFont.TextStyle.title1.rawValue)
        @available(iOS 9.0, *) static let Title2 = AppFont.FromTextStyle(UIFont.TextStyle.title2.rawValue)
        @available(iOS 9.0, *) static let Title3 = AppFont.FromTextStyle(UIFont.TextStyle.title3.rawValue)
        
        
        /**
         iOS gives the opportunity to use dynamic font sizes, based on the current preferred font size the user
         has set in the Settings app of iOS. However, this also includes the preferred font (San Francisco in
         iOS 9).
         This function grabs the size and other traits (bold, italic or not) from a given `UIFontTextStyle`,
         and applies them to predefined `UIFont` of choice (defined in `AppFont.name`)
         
         - Parameter style: a font text style such as `UIFontTextStyleFootnote`.
         - Parameter fontSize: a CGFloat which will be set if not nil, otherwise the standard font size of `style` will be used.
         
         - Returns: a predefined `UIFont` which has the size (or not, see `fontSize`) and other characteristics of the dynamic font style defined in `style`
         */
        static func FromTextStyle(_ style: String, fontSize: CGFloat? = nil) -> UIFont {
            let dynamicFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle(rawValue: style))
            let dynamicFontPointSize = dynamicFontDescriptor.pointSize
            let dynamicFontIsBold = (dynamicFontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) > 0
            let dynamicFontIsItalic = (dynamicFontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) > 0
            
            var toFontDescriptor = UIFontDescriptor(name: name, size: dynamicFontPointSize)
            if dynamicFontIsBold { toFontDescriptor = toFontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)! }
            if dynamicFontIsItalic { toFontDescriptor = toFontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitItalic)! }
            
            let font = UIFont(descriptor: toFontDescriptor, size: fontSize ?? 0.0)
            
            return font
        }
    }
    
    var isBold: Bool {
        return (fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) > 0
    }
    
    var isItalic: Bool {
        return (fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) > 0
    }
    
    var styleAttribute: String? {
        return fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.textStyle] as! String?
    }
}
