//
//  SearchCommunityResultController.h
//  EstateBiz
//
//  Created by wangshanshan on 16/6/20.
//  Copyright © 2016年 Magicsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCommunityResultControllerDelegate <NSObject>

@optional
- (void)updateHistoryRecord:(NSString *)record;

@end
@interface SearchCommunityResultController : UIViewController


@property (nonatomic, assign) id<SearchCommunityResultControllerDelegate>delegate;

@property (nonatomic, copy) NSString *searchword;

@end

