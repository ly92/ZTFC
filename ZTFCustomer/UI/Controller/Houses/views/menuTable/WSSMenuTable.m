//
//  WSSMenuTable.m
//  MenuTable
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 shanshan. All rights reserved.
//

#import "WSSMenuTable.h"
#import "MenuTableCell.h"

#define DDMWIDTH [UIScreen mainScreen].bounds.size.width
#define DDMHEIGHT [UIScreen mainScreen].bounds.size.height

#define DDMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CurrentWindow [self getCurrentWindowView]
static NSString *identifier = @"MenuTableCell";

@interface WSSMenuTable ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView * DropDownMenuView;

@property (nonatomic, weak) UIButton *cover;
//@property (nonatomic, strong) UITableView * leftTableView;
// 当前选中的列
@property (nonatomic, strong) NSMutableArray * currentSelectedRows;
@property (nonatomic, assign) int selectedOption;
@property (nonatomic, assign) BOOL openContentView;

@end

@implementation WSSMenuTable

-(NSMutableArray *)currentSelectedRows{
    if (!_currentSelectedRows) {
        _currentSelectedRows = [NSMutableArray array];
    }
    return _currentSelectedRows;
}

/**
*  初始化变量
*
*  @param origin 原点
*  @param height 导航栏高度
*
*  @return
*/
-(instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height {
   
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, DDMWIDTH, height)];
    if (self) {
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, 0, DDMWIDTH, 0) style:UITableViewStylePlain];
        [self.leftTableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        self.leftTableView.delegate = self;
        self.leftTableView.dataSource = self;
        self.leftTableView.rowHeight = 44;
        [self.DropDownMenuView addSubview:self.leftTableView];
    }
    
    return self;
}


-(UIView *)DropDownMenuView {
    if (_DropDownMenuView == nil) {
        _DropDownMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 0)];
    }
    return _DropDownMenuView;
}


//##################################
+(instancetype)show:(CGPoint)orgin andHeight:(CGFloat)height {
    return [[self alloc] initWithOrgin:orgin andHeight:height];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView {
    self.currrntSelectedColumn = 1100;
    
}

- (void)tableViewWithOption:(int)option animation:(BOOL)show{
    self.selectedOption = option;
    
    if (show) {
        [self removeMenu:0.25];
        [self showSinngleTableData];
    }else{
        [self coverClick];
    }
  
    
}

-(void)showSinngleTableData{
    
    [self setupCover];
    self.DropDownMenuView.backgroundColor = DDMColor(255, 255, 255);
    [UIView animateWithDuration:(0.25) animations:^{
        CGRect frame = CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 260);
        self.DropDownMenuView.frame = frame;
        [CurrentWindow addSubview:self.DropDownMenuView];
        self.leftTableView.frame = CGRectMake(0, 0, DDMWIDTH  , 260);
    }];
    [self.leftTableView reloadData];
    
}
/**获取当前window*/
- (UIWindow *)getCurrentWindowView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    return window;
}

/**
 *  添加遮盖
 */
- (void)setupCover
{
    // 添加一个遮盖按钮
    UIButton *cover = [[UIButton alloc] init];
    CGFloat coverY = self.frame.size.height + self.frame.origin.y;
    cover.frame = CGRectMake(0, coverY, DDMWIDTH, DDMHEIGHT);
    
    [UIView animateWithDuration:0.1 animations:^{
        cover.backgroundColor = [DDMColor(0, 0, 0) colorWithAlphaComponent:0.5];
    }];
    
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [CurrentWindow addSubview:cover];
    self.cover = cover;
}


/**
 *  消失
 */
-(void)dismiss {
    [self coverClick];
}


/**
 *  点击了底部的遮盖，遮盖消失
 */
- (void)coverClick
{
    [self removeMenu:0.2];
    if ([self.delegate respondsToSelector:@selector(didHide)]) {
        [self.delegate didHide];
    }
}

/**
 *  菜单消失
 */
- (void)removeMenu:(CGFloat)AniateTime
{
    [UIView animateWithDuration:(AniateTime) animations:^{
        CGRect frame = CGRectMake(0, self.frame.size.height + self.frame.origin.y, DDMWIDTH, 0);
        self.DropDownMenuView.frame = frame;
        self.leftTableView.frame = CGRectMake(0, 0, DDMWIDTH, 0);
        self.cover.alpha = 0;
        [self.cover removeFromSuperview];

        
    }];
}
/**在VC里的ViewwillDisappear的时候使用*/
-(void)hideMenuTable {
    [self removeMenu:0.25];
}

-(void)setTitleMenuArray:(NSArray *)titleMenuArray{
    _titleMenuArray = titleMenuArray;
    for (NSInteger index = 0; index < self.titleMenuArray.count; index++) {
        /**默认添加全部为0*/
        [self.currentSelectedRows addObject:@(0)];
        
    }
}

#pragma mark -TABLEVIEW DELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.singleDataArray.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.contentLbl.textColor = [UIColor blackColor];
    if (self.singleDataArray.count > indexPath.row) {
        if ([self.delegate respondsToSelector:@selector(showRowDataWithView:AtIndex:withSelectOption:)]) {
            cell.contentLbl.text =  [self.delegate showRowDataWithView:self AtIndex:indexPath withSelectOption:self.selectedOption];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(showRowDataWithCell:View:AtIndex:withSelectOption:)]) {
        [self.delegate showRowDataWithCell:cell View:self AtIndex:indexPath withSelectOption:self.selectedOption];
    }
    
//    NSInteger currentIndex = (self.currrntSelectedColumn-1100);
//    NSInteger  titleSelectRow = [self.currentSelectedRows[currentIndex] integerValue];
//    if (indexPath.row == titleSelectRow) {
//        cell.contentLbl.textColor = [UIColor colorWithRed:9/255.0 green:177/255.0 blue:247/255.0 alpha:1.0];
//        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:titleSelectRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setMenuWithSelectedRow:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowWithView:AtIndexPath:withSeletOption:)]) {
        [self.delegate didSelectRowWithView:self AtIndexPath:indexPath withSeletOption:self.selectedOption];
    }
    
    [self coverClick];
}
/**默认选中的点击的行*/
-(void)setMenuWithSelectedRow:(NSInteger)row {
    self.currentSelectedRows[self.currrntSelectedColumn-1100] = @(row);
}

@end
