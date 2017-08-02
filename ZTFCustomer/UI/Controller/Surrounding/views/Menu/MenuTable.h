//
//  MenuTable.h
//  YiDa
//
//  Created by 沿途の风景 on 14-10-11.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTableDelegate <NSObject>

- (void)didSelectRadius:(NSDictionary *)radius;
- (void)didSelectCategory:(NSDictionary *)category;
- (void)didSelectArea:(NSString *)area;
- (void)didSelectCommunity:(Community *)community district:(NSString *)districtid;
@optional
-(void)didHide;

@end

@interface MenuTable : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *globalTable;
@property (nonatomic, retain) UITableView *areaTable;//所在区域
@property (nonatomic, retain) UITableView *communityTable;//小区
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *bg;//背景半透明
@property (nonatomic, retain) NSMutableArray *menuArray;

@property (nonatomic, assign) BOOL openContentView;

@property (nonatomic, retain) NSMutableArray *categoryArray;
@property (nonatomic, retain) NSMutableArray *distanceArray;

@property (nonatomic, retain) NSString *radiusid;//距离
@property (nonatomic, retain) NSString *districtid;//区域
@property (nonatomic, retain) NSString *categoryid;//分类
@property (nonatomic, retain) NSString *bid;

@property (nonatomic, retain) NSDictionary *radius;
@property (nonatomic, retain) NSDictionary *category;
@property (nonatomic, retain) NSString *tempDistrictid;

@property (nonatomic, assign) id<MenuTableDelegate>delegate;

- (void)loadCommunityInfomationOfDistrict:(NSString *)provinceid cityid:(NSString *)cityid districtid:(NSString *)districtid;

- (void)tableViewWithOption:(int)option animation:(BOOL)show;

-(void)tableViewWithDistrictid:(NSString *)districtId;


@end
