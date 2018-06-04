//
//  CarFootView.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CarFootView.h"
@interface CarFootView ()

@property (nonatomic , strong)UIButton *allBtn;

@property (nonatomic , strong)UILabel *priceLabel;

@property (nonatomic , strong)UIButton *settlementBtn;

@property (nonatomic , assign)BOOL isAll;

@end

@implementation CarFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAll = NO;
        [self creatUI];
    }
    return self;
}
- (void)creatUI
{
    self.allBtn = [UIButton buttonWithTitle:@"全部"
                                    titleColor:[UIColor blackColor]
                               backgroundColor:kClearColor
                                     titleFont:16.0];
    [self.allBtn addTarget:self action:@selector(chouseThis) forControlEvents:UIControlEventTouchUpInside];
    [self.allBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];
    [self.allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];

    [self addSubview:self.allBtn];
    
    self.settlementBtn = [UIButton buttonWithTitle:@"结算"
                                 titleColor:[UIColor whiteColor]
                            backgroundColor:kThemeColor
                                  titleFont:16.0];
    [self.settlementBtn addTarget:self action:@selector(ConfirmOrderGo) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.settlementBtn];
    [self.settlementBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.priceLabel = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentRight
                            backgroundColor:kClearColor
                                       font:FONT(16)
                                  textColor:kThemeColor];
    [self addSubview:self.priceLabel];
    
    self.priceLabel.text = @"合计:0.00";
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(@0);
        make.width.equalTo(@90);
    }];
    
    [self.settlementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(@90);
    }];
                       
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.mas_right);
        make.right.equalTo(self.settlementBtn.mas_left).with.offset(-10);
        make.top.bottom.equalTo(@0);
    }];
    
    
}
- (void)ConfirmOrderGo
{
    if (self.confirmorder) {
        self.confirmorder();
    }
}
- (void)chouseThis
{
    self.isAll = !self.isAll;
    
    if (self.isAll) {
        [self.allBtn setImage:kImage(@"选中YES") forState:UIControlStateNormal];

    }
    else
    {
        [self.allBtn setImage:kImage(@"未选中NO") forState:UIControlStateNormal];

    }
    
    if (self.ischoose) {
        self.ischoose(self.isAll);
    }
    
}
- (void)setPriceA:(NSString *)priceA
{
    _priceA = priceA;
    self.priceLabel.text = priceA;
}
@end
