//
//  HomeCardStyle.h
//  colourlife
//
//  Created by liuyadi on 15/12/16.
//  Copyright © 2015年 liuyadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardLayout.h"

@interface HomeCardStyle : NSObject

+ (CardLayout *)cardStyleWithCollection:(UICollectionView *)collectionView style:(LIMITYACTIVITY_STYLE)style;

+ (CGFloat)cardHeightWithStyle:(LIMITYACTIVITY_STYLE)style dataCount:(NSInteger)count;

@end
