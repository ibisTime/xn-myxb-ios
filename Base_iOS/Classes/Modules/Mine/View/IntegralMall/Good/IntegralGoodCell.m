//
//  IntegralGoodCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralGoodCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

@interface IntegralGoodCell()
//image
@property (nonatomic, strong) UIImageView *goodIV;
//title
@property (nonatomic, strong) UILabel *nameLbl;
//价格
@property (nonatomic, strong) UIButton *priceBtn;

@end

@implementation IntegralGoodCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    CGFloat imgW = (kScreenWidth - 30)/2.0;
    
    self.goodIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgW)];
    
    self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
    self.goodIV.clipsToBounds = YES;
    
    [self addSubview:self.goodIV];
    //价格
    self.priceBtn = [UIButton buttonWithTitle:@""
                                   titleColor:kWhiteColor
                              backgroundColor:kClearColor
                                    titleFont:13.0];
    
    [self.priceBtn setBackgroundImage:kImage(@"积分价格背景") forState:UIControlStateNormal];
    
    self.priceBtn.frame = CGRectMake(self.goodIV.x, self.goodIV.y + 5, 70, 21);
    
    [self addSubview:self.priceBtn];
    //名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(14.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    
    //兑换
    self.exchangeBtn = [UIButton buttonWithTitle:@"我要兑换"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:13.0
                                    cornerRadius:5];
    [self addSubview:self.exchangeBtn];
    
}

- (void)setSubviewLayout {
    
    CGFloat imgW = (kScreenWidth - 10)/2.0;

    //商品名
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.goodIV.mas_bottom).offset(10);
        make.width.equalTo(@(imgW - 20));
    }];

    //兑换按钮
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
        make.height.equalTo(@25);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
}

- (void)setIntegralModel:(IntegralModel *)integralModel {
    
    _integralModel = integralModel;
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:[integralModel.pic convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    [_priceBtn setTitle:[integralModel.price convertToRealMoney] forState:UIControlStateNormal];
    
    _priceBtn.width = _priceBtn.titleLabel.text.length *10 + 20;
    
    _nameLbl.text = integralModel.name;
    //布局
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    CGFloat itemW = (kScreenWidth - 30)/2.0;

    integralModel.size = CGSizeMake(itemW, self.exchangeBtn.yy + 10);
    
}

@end
