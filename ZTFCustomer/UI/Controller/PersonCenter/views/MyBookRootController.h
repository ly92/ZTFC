//
//  MyBookRootController.h
//  ztfCustomer
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyBookRootControllerDelegate <NSObject>

- (void)didSelectRowAtIndexPathTag:(NSInteger)tag ListData:(id)listData;

@end

@interface MyBookRootController : UIViewController

@property (nonatomic, copy) NSString *bid;

@property (nonatomic, assign) NSInteger bookType;
@property (nonatomic, assign) id<MyBookRootControllerDelegate>delegate;
@end
