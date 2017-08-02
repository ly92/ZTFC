//
//  presentView.h
//  colourlife
//
//  Created by ly on 16/1/12.
//  Copyright © 2016年 liuyadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentViewDelegate <NSObject>

- (void)didClickPresentBtn:(NSInteger)count Mobile:(NSString *)mobile;

@end

@interface PresentView : UIView

@property (nonatomic, weak) id<PresentViewDelegate> delegate;

- (instancetype)initWithMax:(int)max;

@end
