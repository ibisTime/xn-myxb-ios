//
//  IntegralMallHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralMallHeaderView.h"
//Manager
#import "TLUser.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
//Extension
//M
//V

@interface IntegralMallHeaderView()

//头像
//昵称
//性别
//积分数
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//性别
@property (nonatomic, strong) UIImageView *genderImg;
//积分数
@property (nonatomic, strong) UILabel *amountLbl;

@end

@implementation IntegralMallHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    CGFloat photoW = 52;
    //头像
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.frame = CGRectMake(15, 15, photoW, photoW);
    self.photoIV.image = USER_PLACEHOLDER_SMALL;
    self.photoIV.layer.cornerRadius = photoW/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoIV];
    
    CGFloat btnHeight = 25;
    
    UIButton *integralBtn = [UIButton buttonWithTitle:@"赚积分"
                                           titleColor:kWhiteColor
                                      backgroundColor:kAppCustomMainColor
                                            titleFont:13.0
                                         cornerRadius:btnHeight/2.0];
    
    [integralBtn addTarget:self action:@selector(getIntegral) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:integralBtn];
    [integralBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.width.equalTo(@50);
        make.centerY.equalTo(@(-22.5));
        make.height.equalTo(@25);
        
    }];
    //昵称
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:17.0];
    
    self.nameLbl.numberOfLines = 0;
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.photoIV.mas_right).offset(15);
        make.height.lessThanOrEqualTo(@(40));
        make.right.equalTo(integralBtn.mas_left).offset(-15);
        
    }];
    
    //性别
    self.genderImg = [[UIImageView alloc] init];
    
    [self addSubview:self.genderImg];
    [self.genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.photoIV.mas_bottom).offset(-(photoW/4.0));
        make.centerX.equalTo(self.photoIV.mas_right).offset(-(photoW/4.0));
        
    }];
    //积分数量
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor2
                                                  font:12.0];
    
    self.amountLbl.backgroundColor = kClearColor;
    
    [self addSubview:self.amountLbl];
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoIV.mas_right).offset(15);
        make.height.lessThanOrEqualTo(@15);
        make.width.lessThanOrEqualTo(@150);
        make.bottom.equalTo(@(-10));
        
    }];
    
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(@85);
    }];
    //积分订单
    //积分记录
    //健康币和积分
    CGFloat y = 85;
    CGFloat w = kScreenWidth/2.0;
    CGFloat h = 45;
    NSArray *typeNames = @[@"积分订单",@"积分记录"];
    NSArray *imgs = @[@"积分订单",@"积分记录"];
    
    [typeNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx*w;
        UIButton *btn = [UIButton buttonWithTitle:typeNames[idx]
                                       titleColor:kTextColor
                                  backgroundColor:kClearColor
                                        titleFont:12.0];
        
        btn.frame = CGRectMake(x, y, w, h);
        [btn setImage:kImage(imgs[idx]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnEvents:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx + 100;
        
        [self addSubview:btn];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    }];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = kLineColor;
    
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@0.5);
        make.top.equalTo(line.mas_bottom).offset(7.5);
    }];
}

#pragma mark - Events

- (void)getIntegral {
    
    if (_block) {
        
        _block(IntegralTypeGetIntegral);
    }
}

- (void)btnEvents:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    
    if (_block) {
        
        IntegralType type = index == 0 ? IntegralTypeIntegralOrder: IntegralTypeIntegralRecord;
        
        _block(type);
    }
}

#pragma mark - Data

- (void)setJfNum:(NSString *)jfNum {
    
    _jfNum = jfNum;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:@"我的积分: " attributes:@{NSFontAttributeName:Font(12.0),NSForegroundColorAttributeName:kTextColor}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_jfNum] attributes:@{NSFontAttributeName:Font(12.0),NSForegroundColorAttributeName:kAppCustomMainColor}];
    
    [nameString appendAttributedString:countString];
    
    self.amountLbl.attributedText = nameString;
}

- (void)changeInfo {
    
    NSString *userPhotoStr = [[TLUser user].photo convertImageUrl];
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:userPhotoStr] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = [TLUser user].nickname;
    
    //    NSString *img = [[TLUser user].userExt.gender isEqualToString:@"1"] ? @"男": @"女生";
    
    //    [self.genderImg setImage:[UIImage imageNamed:img]];
    
    
}

- (void)logout {
    
    [self.photoIV sd_setImageWithURL:nil placeholderImage:USER_PLACEHOLDER_SMALL];
    
    //
    self.nameLbl.text = @"这里有10W+的会员等你一起赚积分!";
    
    //论坛-绞肉机
    self.genderImg.image = nil;
    
    self.amountLbl.text = @"";
}

@end
