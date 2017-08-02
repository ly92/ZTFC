//
//  TextView.m
//  quchicha
//
//  Created by liuyadi on 15/9/9.
//  Copyright (c) 2015年 Vicky. All rights reserved.
//

#import "TextView.h"

@interface TextView ()<UITextViewDelegate>
@property (nonatomic, weak) UILabel *placehoderLabel;
@end

@implementation TextView

- (void)initPlaceholder
{
    self.backgroundColor = [UIColor clearColor];
    
    // 添加一个显示提醒文字的label（显示占位文字的label）
    UILabel *placehoderLabel = [[UILabel alloc] init];
    placehoderLabel.numberOfLines = 0;
    placehoderLabel.backgroundColor = [UIColor clearColor];
    [placehoderLabel setTextColor:[AppTheme subTitleColor]];
    [placehoderLabel setFont:[UIFont systemFontOfSize:15]];
    placehoderLabel.frame = CGRectMake(4, 8, 0, 10);
    [self addSubview:placehoderLabel];
    self.placehoderLabel = placehoderLabel;
    
    // 监听内部文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPlaceholder];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initPlaceholder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    self.placehoderLabel.hidden = self.hasText;
}

#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    
    // 设置文字
    self.placehoderLabel.text = placehoder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.placehoderLabel.y = self.placeholderFrame.origin.y;
//    self.placehoderLabel.x = self.placeholderFrame.origin.x;
    self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLabel.width, MAXFLOAT);
//    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    
    CGSize placehoderSize = [self.placehoder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placehoderLabel.font} context:nil].size;
    self.placehoderLabel.height = placehoderSize.height;
}

- (void)setPlaceholderX:(CGFloat)placeholderX
{
    _placeholderX = placeholderX;
    self.placehoderLabel.x = placeholderX;
}

-(float)resizeFrameWithWithText
{
    //UIFont *tfont = self.font;
    self.font = [UIFont systemFontOfSize:15.0f];
    CGSize s = self.frame.size;
    //NSString *text = self.text;
    if ([ISNull isNilOfSender:self.text]) {
        return 10.0f;
    }
    CGSize size = [self sizeThatFits:CGSizeMake(s.width, s.height+200)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    //[self setFrameSizeHeight:size.height];
    //CGSize size = [text sizeWithFont:tfont constrainedToSize:CGSizeMake(s.width, s.height+200) lineBreakMode:self.lineBreakMode];
    //NSLog(@"--------height=%f,line=%d,func=%s",size.height,__LINE__,__func__);
    /*
     NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
     //[NSDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil];
     CGRect rect = [text boundingRectWithSize:CGSizeMake(s.width, s.height+200) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:tdic context:nil];
     NSLog(@"rect.height=%f,rect.width=%f",rect.size.height,rect.size.width);
     //[self setFrameSizeHeight:size.height];
     self.numberOfLines = 0;
     self.lineBreakMode = NSLineBreakByCharWrapping;
     [self setFrameSize:rect.size];
     //self.backgroundColor = [UIColor redColor];
     */
    return size.height;
}


@end
