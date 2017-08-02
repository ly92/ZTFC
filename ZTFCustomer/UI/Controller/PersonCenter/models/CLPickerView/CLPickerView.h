//
//  CLPickerView.h
//  CLPickerViewDemo
//
//  Created by 树坚 on 16/1/3.
//  Copyright © 2016年 ColourLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLPickerViewDelegate <NSObject>
/*!
 *  每列有多少行
 */
-(NSInteger)CLPickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
/*!
 *  选择器有多少列
 */
-(NSInteger)CLNumberOfComponentsInPickerView:(UIPickerView *)pickerView;
/*!
 *  每列每行返回值
 */
-(NSString*)CLPickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
/*!
 *  选择行
 */
-(void)CLPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface CLPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

/*!
 *  初始化选择器
 *
 *  @param delegate 代理
 *  @param tag      选择器的tag
 *  @param toolbar  是否显示toobar
 */
-(void)PickerViewDelegate:(id<CLPickerViewDelegate>)delegate Tag:(NSInteger)tag IsShowToobar:(BOOL)toolbar;
/*!
 *  为选择器赋值默认行和列
 *
 *  @param row
 *  @param component
 */
-(void)seletedDefaultRow:(NSInteger)row InComponent:(NSInteger)component;

/*!
 *  移除选择器
 */
-(void)removePickerView;

@end
