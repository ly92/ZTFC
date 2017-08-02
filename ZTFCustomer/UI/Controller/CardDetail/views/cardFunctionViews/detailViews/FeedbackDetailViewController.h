//
//  FeedbackDetailViewController.h
//  colourlife
//
//  Created by ly on 16/1/20.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackModel;
@interface FeedbackDetailViewController : UIViewController
- (instancetype)initWFeedback:(FeedbackModel *)feedback;

@property (nonatomic, copy) NSString *relatedId;

@end
