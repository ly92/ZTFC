//
//  CardLayout.h
//  colourlife
//
//  Created by liuyadi on 15/12/17.
//  Copyright © 2015年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardLayout : UICollectionViewLayout

+ (CGSize)sizeOne;

+ (CGSize)sizeTwo;

+ (CGSize)sizeThree;

@property (nonatomic, assign) LIMITYACTIVITY_STYLE cardStyle;

@end
