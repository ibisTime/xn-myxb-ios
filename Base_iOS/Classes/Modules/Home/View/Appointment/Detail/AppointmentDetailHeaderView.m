//
//  AppointmentDetailHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSString+Check.h"

#define kHeadIconWidth 80

@interface AppointmentDetailHeaderView()

//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//性别
@property (nonatomic, strong) UIImageView *genderIV;
//职业
@property (nonatomic, strong) UILabel *jobLbl;
//专长
@property (nonatomic, strong) UILabel *expertiseLbl;
//评分
@property (nonatomic, strong) UIView *starView;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation AppointmentDetailHeaderView

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
    
    //头像
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.layer.cornerRadius = kHeadIconWidth/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = [UIColor clearColor];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoIV];
    //昵称
    self.nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:16.0];
    
    [self addSubview:self.nickNameLbl];
    //性别
    self.genderIV = [[UIImageView alloc] init];
    
    self.genderIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.genderIV];
    //职业
    self.jobLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor
                                               font:13.0];
    [self addSubview:self.jobLbl];
    //专长
    self.expertiseLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:13.0];
    [self addSubview:self.expertiseLbl];
    //评分
    self.starView = [[UIView alloc] init];
    
    [self addSubview:self.starView];
}

- (void)setSubviewLayout {
    
    if (_isFirst) {
        
        return;
    }
    
    CGFloat leftMargin = 15;
    
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(20));
        make.width.height.equalTo(@(kHeadIconWidth));
    }];
    //昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_top).offset(2);
        make.left.equalTo(self.photoIV.mas_right).offset(leftMargin);
        make.height.equalTo(@18);
    }];
    
    //性别
    CGFloat genderW = 14;
    
    [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_right).offset(8);
        make.width.height.equalTo(@(genderW));
        make.centerY.equalTo(self.nickNameLbl.mas_centerY);
    }];
    
    //职业
    [self.jobLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(5);
    }];
    
    //专长
    [self.expertiseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.jobLbl.mas_right).offset(8);
        make.top.equalTo(self.jobLbl.mas_top);
    }];
    
    //评分
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.bottom.equalTo(self.photoIV.mas_bottom).offset(-5);
    }];
    
    __block CGFloat x = kHeadIconWidth + 30;
    //风格
    [_detailModel.styles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = _detailModel.styles[idx];
        
        if (![title valid]) {
            
            return ;
        }
        
        CGFloat w = [NSString getWidthWithString:title font:11.0] + 10;
        
        UIButton *btn = [UIButton buttonWithTitle:title
                                       titleColor:_detailModel.styleColor[idx]
                                  backgroundColor:kWhiteColor
                                        titleFont:11.0
                                     cornerRadius:8.5];
        
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = _detailModel.styleColor[idx].CGColor;
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.top.equalTo(self.jobLbl.mas_bottom).offset(6);
            make.width.equalTo(@(w));
            make.height.equalTo(@17);
        }];
        
        x += w+10;
    }];
    //星星
    for (int i = 0; i < 5; i++) {
        
        CGFloat x = i*15;
        CGFloat w = 10;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.image = i < [_detailModel.level integerValue] ? kImage(@"big_star_select"): kImage(@"big_star_unselect");
        
        [self.starView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
    }
    
    _isFirst = YES;
}

#pragma mark - Setting
- (void)setDetailModel:(AppointmentListModel *)detailModel {
    
    _detailModel = detailModel;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[detailModel.photo convertImageUrl]]
                    placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nickNameLbl.text = detailModel.realName;
    
    self.genderIV.image = [detailModel.gender isEqualToString:@"0"] ? kImage(@"女生"): kImage(@"男士");

    self.jobLbl.text = [detailModel getUserType];
    
    self.expertiseLbl.text = [detailModel.speciality valid] ?
    [NSString stringWithFormat:@"专长: %@", detailModel.speciality]: @"";
    //布局
    [self setSubviewLayout];
    
}

@end
