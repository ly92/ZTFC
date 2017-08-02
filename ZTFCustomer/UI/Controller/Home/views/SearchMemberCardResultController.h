//
//  SearchMemberCardResultController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/17.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchMemberCardResultControllerDelegate <NSObject>

@optional
- (void)updateHistoryRecord:(NSString *)record;

@end


@interface SearchMemberCardResultController : UIViewController

@property (nonatomic, assign) id<SearchMemberCardResultControllerDelegate>delegate;


@property (nonatomic, copy) NSString *searchword;


@end
