//
//  TripListView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TripListView.h"
#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface TripListView()

//背景
@property (nonatomic, strong) UIView *bgView;
//确认按钮
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation TripListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    
    //档期时间
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:16.0];
    
    [self.bgView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@35);
    }];
    //icon
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"时间")];
    
    [self.bgView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(textLbl.mas_left).offset(-15);
        make.centerY.equalTo(textLbl.mas_centerY);
    }];
    
    //我知道了
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"我知道了"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:14.0
                                        cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:confirmBtn];
    
    self.confirmBtn = confirmBtn;
}

- (void)setSubviewLayout {
    
    //我知道了
//    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@(-kWidth(30)));
//        make.top.equalTo(promptLbl.mas_bottom).offset(35);
//        make.width.equalTo(@(kWidth(110)));
//        make.height.equalTo(@35);
//    }];
//
    [self layoutSubviews];
    
    //背景
    CGFloat bgW = kScreenWidth - 2*kWidth(35);
    CGFloat bgH = self.confirmBtn.yy + 35;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.height.equalTo(@(bgH));
        make.width.equalTo(@(bgW));
    }];
}

#pragma mark - Setting
//- (void)setPriceModel:(OrderPriceModel *)priceModel {
//
//    _priceModel = priceModel;
//
//    self.priceLbl.text = [NSString stringWithFormat:@"%@ CNY", priceModel.price];
//
//    self.amountLbl.text = [NSString stringWithFormat:@"%@ CNY", priceModel.amount];
//
//    self.numLbl.text = [NSString stringWithFormat:@"%@ ETH", priceModel.num];
//
//}

#pragma mark - Events
- (void)confirm {
    
    [self hide];
}

- (void)cancel {
    
    [self hide];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
}

@end
