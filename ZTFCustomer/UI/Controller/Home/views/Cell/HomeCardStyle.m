//
//  HomeCardStyle.m
//  colourlife
//
//  Created by liuyadi on 15/12/16.
//  Copyright © 2015年 liuyadi. All rights reserved.
//

#import "HomeCardStyle.h"

@implementation HomeCardStyle

+ (CGFloat)cardHeightWithStyle:(LIMITYACTIVITY_STYLE)style dataCount:(NSInteger)count
{
    CGFloat height = 0;
    NSInteger row = (count % 2 == 0) ? (count / 2) : (count / 2) + 1;
//    NSInteger row = (count / 2) + 1;
    switch (style) {
        case LIMITYACTIVITY_STYLE_DEFAULT1:
        {
            height = count * [CardLayout sizeOne].height + (count - 1) * 1;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT2:
        {
            height = count * [CardLayout sizeOne].height + (count - 1) * 1;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT3:
        {
            height = row * [CardLayout sizeThree].height;
            if ( row > 1 )
            {
                height += ((row - 1) * 1);
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT4:
        {
            height = row * [CardLayout sizeTwo].height;
            if ( row > 1 )
            {
                height += ((row - 1) * 1);
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT5:
        {
            height = [CardLayout sizeTwo].height * 2 + 1;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT6:
        {
            height = [CardLayout sizeOne].height + [CardLayout sizeTwo].height;
            height += 1;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT7:
        {
            height = row * [CardLayout sizeTwo].height;
            if ( row > 1 )
            {
                height += ((row - 1) * 1);
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT8:
        {
            NSUInteger rows = (count - 1) % 2 == 0 ? (count - 1) / 2 : ((count - 1) / 2) + 1;
//            NSUInteger rows = ((count - 2) / 2) + 1;
            height = [CardLayout sizeOne].height + [CardLayout sizeTwo].height * rows;
            height += ((1 + rows) * 1);
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT9:
        {
            NSUInteger rows = (count - 2) % 2 == 0 ? (count - 2) / 2 : ((count - 2) / 2) + 1;
//            NSUInteger rows = ((count - 2) / 2) + 1;
            height = [CardLayout sizeOne].height * 2;
            height += [CardLayout sizeTwo].height * rows;
            height += (2 + rows) * 1;
            break;
        }
        default:
            height = 0;
            break;
    }
    return MAX(0, height);
}

+ (CardLayout *)cardStyleWithCollection:(UICollectionView *)collectionView style:(LIMITYACTIVITY_STYLE )style
{
    CardLayout * layout = (CardLayout *)collectionView.collectionViewLayout;
    layout.cardStyle = style;
    return layout;
}

@end
