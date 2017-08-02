//
//  MessageRootViewController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/3.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MessageRootViewControllerDelegate <NSObject>

- (void)didSelectRowAtIndexPathTag:(NSInteger)tag ListData:(id)listData;

@end

@interface MessageRootViewController : UIViewController

@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, assign) id<MessageRootViewControllerDelegate>delegate;

@end
