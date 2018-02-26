//
//  BrandDetailHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandDetailHeaderView.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
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
#import "DetailWebView.h"

@interface BrandDetailHeaderView()
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//产品
@property (nonatomic, strong) UIView *goodView;
//产品名称
@property (nonatomic, strong) UILabel *nameLbl;
//产品说明
@property (nonatomic, strong) UILabel *descLbl;
//产品价格
@property (nonatomic, strong) UILabel *priceLbl;
//产品销量
@property (nonatomic, strong) UILabel *numLbl;
//
@property (nonatomic, strong) UIView *whiteView;
//图文详情
@property (nonatomic, strong) DetailWebView *detailWebView;

@end

@implementation BrandDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        [self initBannerView];
        //产品
        [self initGoodView];
        //图文详情
        [self initWebView];
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
    //产品名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self.goodView addSubview:self.nameLbl];
    //产品说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self.goodView addSubview:self.descLbl];
    //产品价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kThemeColor
                                                 font:18.0];
    
    [self.goodView addSubview:self.priceLbl];
    //产品销量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor2
                                               font:14.0];
    
    [self.goodView addSubview:self.numLbl];
    
}

- (void)initWebView {
    
    BaseWeakSelf;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    
    self.whiteView = whiteView;
    
    //line
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kThemeColor;
    
    [whiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@3);
        make.height.equalTo(@13.5);
    }];
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                        
                                               textColor:kTextColor
                                                    font:14.0];
    
    textLbl.text = @"商品详情";
    [whiteView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(line.mas_centerY);
        make.left.equalTo(line.mas_right).offset(10);
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [whiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];

    
    //图文详情
    self.detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, whiteView.yy + 90, kScreenWidth, 40)];
    
    self.detailWebView.webViewBlock = ^(CGFloat height) {
        
        [weakSelf setSubViewLayoutWithHeight:height];
    };
    
    [self addSubview:self.detailWebView];
    
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;

    //产品名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@40);
    }];
    //产品说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@20);
    }];
    //产品价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.descLbl.mas_bottom).offset(10);
    }];
    //产品销量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.priceLbl.mas_centerY);
    }];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    //
    [self layoutIfNeeded];
    
    self.goodView.height = _priceLbl.yy + 15;
    
    self.whiteView.y = self.goodView.yy + 10;
    
    self.detailWebView.webView.scrollView.height = height;
    self.detailWebView.frame = CGRectMake(0, self.whiteView.yy, kScreenWidth, height);
    
    self.height = self.detailWebView.yy;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeaderViewDidLayout" object:nil];
}

#pragma mark - Setting
- (void)setDetailModel:(BrandModel *)detailModel {
    
    _detailModel = detailModel;
    
    _bannerView.imgUrls = detailModel.pics;
    
    _nameLbl.text = detailModel.name;
    _descLbl.text = detailModel.slogan;
    
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [detailModel.price convertToSimpleRealMoney]];
    
    _numLbl.text = [NSString stringWithFormat:@"已售: %ld", detailModel.soldOutCount];
    [_detailWebView loadWebWithString:detailModel.desc];

    //布局
    [self setSubviewLayout];
    
}

@end
