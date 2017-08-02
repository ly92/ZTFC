//
//  AlertView.h
//  fomo
//
//  Created by Chenyun on 15/3/18.
//  Copyright (c) 2015年 Geek Zoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertView;

#pragma mark - 控件的类型
typedef enum {
	AlertViewTypeNode = 0,
	AlertViewTypeMonospaced = 1
} AlertViewType;

/**
 *  [self.container hideWithCompetion:^(BOOL finished) {
 *      PERFORM_BLOCK_SAFELY(self.whenSeleced, signal.name);
 *  }];
 */
@protocol AlertContentView <NSObject>
@property (nonatomic, weak) AlertView * container;
@property (nonatomic, copy) void (^whenSeleced)(NSString *signal, BOOL isSendMessage);
@property (nonatomic, copy) void (^whenRegistered)(id data);
@property (nonatomic, copy) void (^whenHide)(BOOL hide);
@end

@interface AlertView : UIView

- (instancetype)initWithContent:(UIView<AlertContentView> *)content type:(AlertViewType)type;

- (void)show;
- (void)showIn:(UIView *)container;

- (void)hide;
- (void)hideWithCompetion:(void (^)(BOOL finished))completion;

- (void)showSharedView;
- (void)showModifyViewIn:(UIView *)container;

- (void)setViewYWithNumber:(NSInteger)number;

@end