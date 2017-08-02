//
//  WSSMenuTable.h
//  MenuTable
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 shanshan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSSMenuTable;
@class MenuTableCell;

@protocol  WSSMenuTableDelegate <NSObject>

@required

-(NSString *)showRowDataWithView:(WSSMenuTable *)menuTable AtIndex:(NSIndexPath *)indexPath withSelectOption:(NSInteger)selectOption;

-(void)showRowDataWithCell:(MenuTableCell *)cell View:(WSSMenuTable *)menuTable AtIndex:(NSIndexPath *)indexPath withSelectOption:(NSInteger)selectOption;

- (void)didSelectRowWithView:(WSSMenuTable *)menuTable AtIndexPath:(NSIndexPath *)indexPath withSeletOption:(NSInteger)selectOption;

-(void)didHide;

@end

@interface WSSMenuTable : UIView

@property (nonatomic, strong) UITableView * leftTableView;

// 当前选中的Tag
@property (nonatomic, assign) NSInteger  currrntSelectedColumn;
@property (nonatomic, strong) NSArray *titleMenuArray;
@property (nonatomic, strong) NSMutableArray *singleDataArray;

// 显示
+(instancetype)show:(CGPoint)orgin andHeight:(CGFloat)height;
-(instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height;

@property (nonatomic, weak) id<WSSMenuTableDelegate> delegate;

-(void)hideMenuTable;

- (void)tableViewWithOption:(int)option animation:(BOOL)show;

@end
