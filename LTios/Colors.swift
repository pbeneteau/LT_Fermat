//
//  Colors.swift
//  LTios
//
//  Created by Paul Bénéteau on 04/10/2017.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

struct Color {
    
    static let mainAppColor = UIColor(red:0.38, green:0.55, blue:0.96, alpha:1.0)
    
    struct Button {
        
        struct Background {
            static let normal = mainAppColor
            static let active = UIColor.white
        }
        struct Border {
            static let normal = mainAppColor
            static let active = mainAppColor
        }
        struct Title {
            static let normal = UIColor.white
            static let active = mainAppColor
        }
    }
    
    struct Menu {
        
        struct Button {
            static let normal = UIColor(red:0.11, green:0.20, blue:0.35, alpha:1.0)
            static let ghost = UIColor.white
            static let unreachable = UIColor.white
            static let nearbyPlacesView = UIColor.white
        }
        struct SelectionBar {
            static let normal = UIColor(red:0.11, green:0.20, blue:0.35, alpha:1.0)
            static let ghost = UIColor.white
            static let unreachable = UIColor.white
            static let nearbyPlacesView = UIColor.white
        }
        struct Title {
            static let normal = UIColor.white
            static let mainView = mainAppColor
        }
    }
    
    struct Profile {
        
        static let publicName = UIColor(red:0.00, green:0.05, blue:0.25, alpha:1.0)
        static let badge = UIColor.lightGray
    }
    
    struct NearbyPlaces {
        
        struct FilterCollectionView {
            
            struct Background {
                static let selected = UIColor.black
                static let normal = UIColor.white
            }
            
            struct Label {
                static let selected = UIColor.white
                static let normal = UIColor.lightGray
            }
        }
    }
    
    static let separatorLine = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)

    static let roundedBlockView = UIColor.white
    
    static let viewControllerBackground = UIColor(red:0.95, green:0.94, blue:0.95, alpha:1.0)
    
    static let menuContainerView = UIColor.white
    
    static let blockBackground = UIColor.white
    
    struct mainMenu {
        static let background = UIColor.white
        static let tint = UIColor.black
    }
    
    struct AlertBanner {
        
        struct Ghost {
            static let title = UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.0)
            static let description = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        }
        struct Message {
            static let title = mainAppColor
            static let description = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        }
        struct ClosePeople {
            static let title = mainAppColor
            static let description = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
        }
        struct Unreachable {
            static let title = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            static let description = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        }
    }
}


