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
#import "NSString+Date.h"

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
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor
                                               alpha:0.6];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    
    //档期时间
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kThemeColor
                                                    font:16.0];
    textLbl.text = @"档期时间";
    textLbl.frame = CGRectMake(0, 35, 70, 16);
    textLbl.tag = 2000;
    
    [self.bgView addSubview:textLbl];
    
    //icon
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"时间")];
    
    iconIV.tag = 2001;
    [self.bgView addSubview:iconIV];
    
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

#pragma mark - Setting
- (void)setTrips:(NSArray<TripInfoModel *> *)trips {

    _trips = trips;

    //背景
    CGFloat bgW = kScreenWidth - 2*kWidth(35);
    
    UILabel *textLbl = [self viewWithTag:2000];
    UIImageView *iconIV = [self viewWithTag:2001];
    
    __block CGFloat y = textLbl.yy + 25;
    
    [trips enumerateObjectsUsingBlock:^(TripInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *timeLbl = [UILabel labelWithFrame:CGRectMake(0, y, bgW, kFontHeight(12.0))
                                      textAligment:NSTextAlignmentCenter
                                   backgroundColor:kClearColor
                                              font:Font(12.0)
                                         textColor:kTextColor];
        //开始时间
        NSString *startTime = [obj.startDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm"];
        //结束时间
        NSString *endTime = [obj.endDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm"];

        timeLbl.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        
        [self.bgView addSubview:timeLbl];
        y += 32;
    }];
    
    _confirmBtn.frame = CGRectMake((bgW - kWidth(250))/2.0, y + 40, kWidth(250), 35);
    
    CGFloat bgH = self.confirmBtn.yy + 35;
    
    self.bgView.frame = CGRectMake(0, 0, bgW, bgH);
    self.bgView.center = self.center;
    
    textLbl.centerX = self.bgView.centerX - 10;
    iconIV.frame = CGRectMake(textLbl.x - 28, 0, 18, 18);
    iconIV.centerY = textLbl.centerY;
    
}

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
