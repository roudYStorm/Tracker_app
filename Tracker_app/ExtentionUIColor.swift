import UIKit

extension UIColor {
    static var blueColor: UIColor { #colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1) }
    static var subtitleLabelColor: UIColor { #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1) }
    static var unselectedTabBarIcon: UIColor { #colorLiteral(red: 0.69, green: 0.6910327673, blue: 0.6910327673, alpha: 1) }
    static var backgroudColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1) :  // Цвет для тёмной темы
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)  // Цвет для светлой темы
        }
    }
    static var buttonColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) :  // Цвет для тёмной темы
            #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)  // Цвет для светлой темы
        }
    }
    static var addButtonColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1) :  // Цвет для тёмной темы
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)  // Цвет для светлой темы
        }
    }
    static var searchBarColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.24) :  // Цвет для тёмной темы
            #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.12)  // Цвет для светлой темы
        }
    }
    
    static var grey: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9215686275, alpha: 1) :  // Цвет для тёмной темы
            #colorLiteral(red: 0.9212860465, green: 0.9279851317, blue: 0.9373531938, alpha: 1)  // Цвет для светлой темы
        }
    }
    static var greyColorCell: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 0.85) :  // Цвет для тёмной темы
            #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.937254902, alpha: 0.3033940397)  // Цвет для светлой темы
        }
    }
    static var textColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1) :  // Цвет для тёмной темы
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)  // Цвет для светлой темы
        }
    }
    static var cellColor1: UIColor { #colorLiteral(red: 0.9921568627, green: 0.2980392157, blue: 0.2862745098, alpha: 1) }
    static var cellColor2: UIColor { #colorLiteral(red: 1, green: 0.5333333333, blue: 0.1176470588, alpha: 1) }
    static var cellColor3: UIColor { #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9803921569, alpha: 1) }
    static var cellColor4: UIColor { #colorLiteral(red: 0.431372549, green: 0.2666666667, blue: 0.9960784314, alpha: 1) }
    static var cellColor5: UIColor { #colorLiteral(red: 0.2, green: 0.8117647059, blue: 0.4117647059, alpha: 1) }
    static var cellColor6: UIColor { #colorLiteral(red: 0.9019607843, green: 0.4274509804, blue: 0.831372549, alpha: 1) }
    static var cellColor7: UIColor { #colorLiteral(red: 0.9764705882, green: 0.831372549, blue: 0.831372549, alpha: 1) }
    static var cellColor8: UIColor { #colorLiteral(red: 0.2039215686, green: 0.6549019608, blue: 0.9960784314, alpha: 1) }
    static var cellColor9: UIColor { #colorLiteral(red: 0.2745098039, green: 0.9019607843, blue: 0.6156862745, alpha: 1) }
    static var cellColor10: UIColor { #colorLiteral(red: 0.2078431373, green: 0.2039215686, blue: 0.4862745098, alpha: 1) }
    static var cellColor11: UIColor { #colorLiteral(red: 1, green: 0.4039215686, blue: 0.3019607843, alpha: 1) }
    static var cellColor12: UIColor { #colorLiteral(red: 1, green: 0.6, blue: 0.8, alpha: 1) }
    static var cellColor13: UIColor { #colorLiteral(red: 0.9647058824, green: 0.768627451, blue: 0.5450980392, alpha: 1) }
    static var cellColor14: UIColor { #colorLiteral(red: 0.4745098039, green: 0.5803921569, blue: 0.9607843137, alpha: 1) }
    static var cellColor15: UIColor { #colorLiteral(red: 0.5137254902, green: 0.1725490196, blue: 0.9450980392, alpha: 1) }
    static var cellColor16: UIColor { #colorLiteral(red: 0.6784313725, green: 0.337254902, blue: 0.8549019608, alpha: 1) }
    static var cellColor17: UIColor { #colorLiteral(red: 0.5529411765, green: 0.4470588235, blue: 0.9019607843, alpha: 1) }
    static var cellColor18: UIColor { #colorLiteral(red: 0.1843137255, green: 0.8156862745, blue: 0.3450980392, alpha: 1) }
}

