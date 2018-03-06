//
//  IntegralGoodHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralGoodHeaderView.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
//M
#import "BannerModel.h"
//V
#import "TLBannerView.h"

@interface IntegralGoodHeaderView()
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//产品
@property (nonatomic, strong) UIView *goodView;
//图标
@property (nonatomic, strong) UIImageView *iconIV;
//产品说明
@property (nonatomic, strong) UILabel *descLbl;
//产品价格
@property (nonatomic, strong) UILabel *priceLbl;
//产品库存
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation IntegralGoodHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        [self initBannerView];
        //产品
        [self initGoodView];
    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(375))];
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initGoodView {
    
    self.goodView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 120)];
    
    self.goodView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.goodView];
    
    //产品说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self.goodView addSubview:self.descLbl];
    //图标
    self.iconIV = [[UIImageView alloc] initWithImage:kImage(@"积分")];
    
    [self.goodView addSubview:self.iconIV];
    //产品价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:[UIColor colorWithHexString:@"#ffbe00"]
                                                 font:14.0];
    
    [self.goodView addSubview:self.priceLbl];
    //产品销量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor2
                                               font:12.0];
    
    [self.goodView addSubview:self.numLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    
    //产品名称
//    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.equalTo(@(leftMargin));
//        make.right.equalTo(@(-leftMargin));
//        make.height.lessThanOrEqualTo(@40);
//    }];
    //产品说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.right.equalTo(@(-leftMargin));
    }];
    //图标
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(self.descLbl.mas_bottom).offset(13);
        make.width.height.equalTo(@18);
    }];
    //产品价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconIV.mas_right).offset(10.0);
        make.centerY.equalTo(self.iconIV.mas_centerY);
    }];
    //产品销量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.priceLbl.mas_centerY);
    }];
}

#pragma mark - Setting
- (void)setGood:(IntegralModel *)good {
    
    _good = good;
    
    _bannerView.imgUrls = good.pics;
    _descLbl.text = good.slogan;
    _priceLbl.text = [NSString stringWithFormat:@"%@积分", [good.price convertToRealMoney]];
    _numLbl.text = [NSString stringWithFormat:@"当前剩余: %ld", good.quantity];
    
    //布局
    [self setSubviewLayout];
    //
    [self layoutIfNeeded];
    
    self.goodView.height = _iconIV.yy + 12;
    
    self.height = self.goodView.yy;
}

@end
