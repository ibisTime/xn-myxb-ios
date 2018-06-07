//
//  ChousePayView.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ChousePayView.h"
@interface ChousePayView ()
@property (nonatomic , strong)NSMutableArray *buttonArray;
@property (nonatomic , strong)UIButton *weixin;
@property (nonatomic , strong)UIButton *zhifubao;
@end

@implementation ChousePayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonArray = [NSMutableArray arrayWithCapacity:0];
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    
    
    UILabel *title = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:13];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = @"支付方式";
    [self addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(13);
        make.right.equalTo(self.mas_right);

        make.top.equalTo(@5);
        make.height.equalTo(@20);
    }];
    
    [self creatButton:@"微信充值" money:@"微信" index:0];
    self.weixin = [self.buttonArray objectAtIndex:0];
    self.weixin.selected = YES;
    [self creatButton:@"支付宝" money:@"支付宝" index:1];
    self.zhifubao = [self.buttonArray objectAtIndex:1];
    
}
/**
 *  创建一个可选择的button
 *
 *  @param monthTitle 月份
 *  @param money      钱数
 *  @param index      索引
 */
-(void)creatButton:(NSString *)monthTitle money:(NSString *)money index:(int)index
{
    
    
    
    //背景
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, index * 60 + 23,kScreenWidth, 60);
    [self addSubview:bgView];
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = kSilverGreyColor;
    [bgView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_top);
        make.height.equalTo(@.5);
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
    imageview.image = kImage(monthTitle);
    [bgView addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).with.offset(15);
        make.centerY.equalTo(bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    
    UILabel *title = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = money;
    [bgView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).with.offset(10);
        make.centerY.equalTo(bgView.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    
    //选择的事件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    btn.tag = index;
    btn.frame = CGRectMake(0, 0, kScreenWidth, 60);
    [btn addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"选中YES"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"未选中NO"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth - 60, 0, 0)];
    [bgView addSubview:btn];
    [self.buttonArray addObject:btn];
}
//点击那个数目
-(void)selectedButtonClick:(UIButton *)sender
{
    if (sender == self.weixin) {
        self.weixin.selected = YES;
        self.zhifubao.selected = NO;
    }
    else
    {
        self.weixin.selected = NO;
        self.zhifubao.selected = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitMoneyButtonClickWithMoney:)]) {
        [self.delegate commitMoneyButtonClickWithMoney:self.weixin.selected];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
