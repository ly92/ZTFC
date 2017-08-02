//
//  CardPointDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardPointData;

@interface CardPointDetailViewController : UIViewController
- (instancetype)initWithPoint:(CardPointData *)point Name:(NSString *)name;
@end
