//
//  CardLayout.m
//  colourlife
//
//  Created by liuyadi on 15/12/17.
//  Copyright © 2015年 liuyadi. All rights reserved.
//

#import "CardLayout.h"

@implementation CardLayout

+ (CGSize)sizeOne
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size.width = ([UIScreen mainScreen].bounds.size.width);
        size.height = size.width * 0.5;
    });
    return size;
}

+ (CGSize)sizeTwo
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size.width = ([UIScreen mainScreen].bounds.size.width - 1) * 0.5;
        size.height = size.width * 0.6;
    });
    return size;
}

+ (CGSize)sizeThree
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size.width = ([UIScreen mainScreen].bounds.size.width - 1) * 0.5;
        size.height = size.width * 0.6 * 2 + 2;
    });
    return size;
}

// 返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize
{
    CGFloat height = 0;
    switch (self.cardStyle)
    {
        case LIMITYACTIVITY_STYLE_DEFAULT1:
        {
            height = [CardLayout sizeOne].height;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT2:
        {
            height = [CardLayout sizeOne].height * 2 + 2;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT3:
        {
            height = [CardLayout sizeThree].height;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT4:
        {
            height = [CardLayout sizeTwo].height * 2 + 2;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT5:
        {
            height = [CardLayout sizeTwo].height * 2 + 2;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT6:
        {
            height = [CardLayout sizeOne].height + [CardLayout sizeTwo].height;
            height += 2;
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT7:
        {
            height = [CardLayout sizeTwo].height * 3;
            height += (2 * 2);
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT8:
        {
            height = [CardLayout sizeOne].height + [CardLayout sizeTwo].height * 2;
            height += (2 * 2);
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT9:
        {
            height = ([CardLayout sizeOne].height + [CardLayout sizeTwo].height) * 2;
            height += (3 * 2);
            break;
        }
        default:
            break;
    }
    
    CGSize contentSize = CGSizeMake(0, height);
    
    return contentSize;
}

//  初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * attributes = [NSMutableArray array];
    
    for (int i = 0; i < [self.collectionView numberOfSections]; i++)
    {
        [attributes addObjectsFromArray:[self layoutAttributesForSection:i]];
    }
    
    return attributes;
}

- (NSArray *)layoutAttributesForSection:(NSUInteger)section
{
    NSUInteger count = [self.collectionView numberOfItemsInSection:section];
    
    CGPoint origin = CGPointZero;
    
    CGRect lastFrame = CGRectZero;
    
    NSMutableArray * array = [NSMutableArray array];
    
    CGFloat padding = 1;
    
    switch ( self.cardStyle ) {
        case LIMITYACTIVITY_STYLE_DEFAULT1:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else
                {
                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT2:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else
                {
                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT3:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                NSUInteger row = i / 2 == 0 ? 0 : 1;
                if ( i % 2 == 0 )
                {
                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeThree].width, [CardLayout sizeThree].height);
                    lastFrame = frame;
                }
                else
                {
                    frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeThree].width, [CardLayout sizeThree].height);
                    lastFrame = frame;
                }
                
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT4:
        {
//            [[AppDelegate sharedAppDelegate]showNoticeMsg:@"样式4布局" WithInterval:1.0];
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                NSUInteger row = i / 2 == 0 ? 0 : 1;
                if ( i % 2 == 0 )
                {
                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                else
                {
                    frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
//                [[AppDelegate sharedAppDelegate]showNoticeMsg:[NSString stringWithFormat:@"cell %d frame :%f",i,frame.size.width] WithInterval:1.5f];
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT5:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(origin.x, origin.y, [CardLayout sizeThree].width, [CardLayout sizeThree].height);
                    lastFrame = frame;
                }
                else if ( i == 1 )
                {
                    frame = CGRectMake(CGRectGetMaxX(lastFrame) + padding, 0, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                else if ( i == 2 )
                {
                    frame = CGRectMake(lastFrame.origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                }
                else
                {
                    frame = CGRectZero;
                    lastFrame = frame;
                }
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT6:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(origin.x, origin.y, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else if ( i == 1 )
                {
                    frame = CGRectMake(0, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                else if ( i == 2 )
                {
                    frame = CGRectMake(CGRectGetMaxX(lastFrame) + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                }
                else
                {
                    frame = CGRectZero;
                    lastFrame = frame;
                }
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT7:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                NSUInteger row = i / 2 == 0 ? 0 : 1;
                if ( i % 2 == 0 )
                {
                    frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + (row * padding), [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                else
                {
                    frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                    lastFrame = frame;
                }
                
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT8:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(0, 0, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else
                {
                    if ( (i - 1) % 2 == 0 )
                    {
                        frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                        lastFrame = frame;
                    }
                    else
                    {
                        frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                        lastFrame = frame;
                    }

                }
                
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        case LIMITYACTIVITY_STYLE_DEFAULT9:
        {
            for ( int i = 0; i < count; i++ )
            {
                CGRect frame;
                
                if ( i == 0 )
                {
                    frame = CGRectMake(0, 0, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else if ( i == count - 1 )
                {
                    frame = CGRectMake(0, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeOne].width, [CardLayout sizeOne].height);
                    lastFrame = frame;
                }
                else
                {
                    if ( (i - 1) % 2 == 0 )
                    {
                        frame = CGRectMake(origin.x, CGRectGetMaxY(lastFrame) + padding, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                        lastFrame = frame;
                    }
                    else
                    {
                        frame = CGRectMake([CardLayout sizeTwo].width + padding, lastFrame.origin.y, [CardLayout sizeTwo].width, [CardLayout sizeTwo].height);
                        lastFrame = frame;
                    }
                    
                }
                
                UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
                
                attributes.frame = frame;
                
                [array addObject:attributes];
            }
            break;
        }
        default:
            break;
    }
    
    return array;
}

- (void)setCardStyle:(LIMITYACTIVITY_STYLE)cardStyle
{
//    [[AppDelegate sharedAppDelegate]showNoticeMsg:@"cardlayout布局" WithInterval:1.0];
    _cardStyle = cardStyle;
    [self layoutAttributesForElementsInRect:CGRectZero];
}

@end
