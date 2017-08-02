//
//  UICollectionView+QuickReusing.h
//
//  Created by QFish on 7/19/15.
//  Copyright (c) 2015 QFish. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

@interface UICollectionReusableView (QuickReusing)
+ (void)registerNibTo:(UICollectionView *)collectionView;
+ (void)registerClassTo:(UICollectionView *)collectionView;
+ (void)registerNibTo:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerClassTo:(UICollectionView *)collectionView kind:(NSString *)kind;
@end

#pragma mark -

@interface UICollectionView (QuickReusing)

// Register reusing cell
- (void)registerNib:(NSString *)nibName;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle;
- (void)registerClass:(NSString *)className;
// Register reusing header or footer
- (void)registerNib:(NSString *)nibName kind:(NSString *)kind;
- (void)registerNib:(NSString *)nibName bundle:(NSBundle *)bundle kind:(NSString *)kind;
- (void)registerClass:(NSString *)className kind:(NSString *)kind;

// Dequeue cell
- (id)dequeue:(id)identifier forIndexPath:(NSIndexPath*)indexPath;
- (id)dequeue:(id)identifier kind:(NSString *)kind forIndexPath:(NSIndexPath*)indexPath;

@end
