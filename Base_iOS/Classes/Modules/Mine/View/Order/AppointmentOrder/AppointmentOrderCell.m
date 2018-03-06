//
//  AppointmentOrderCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentOrderCell.h"
//Category
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "NSString+Date.h"

@interface AppointmentOrderCell()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//预约开始时间
@property (nonatomic, strong) UILabel *startDateLbl;
//预约天数
@property (nonatomic, strong) UILabel *dayLbl;

@end

@implementation AppointmentOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //头像
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    self.photoIV.clipsToBounds = YES;
    self.photoIV.layer.cornerRadius = 40;
    
    [self addSubview:self.photoIV];
    
    //昵称
    self.nickNameLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:Font(13.0)
                                  textColor:kThemeColor];
    [self addSubview:self.nickNameLbl];
    
    //预约开始时间
    self.startDateLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kClearColor
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.startDateLbl.numberOfLines = 0;
    
    [self addSubview:self.startDateLbl];
    
    //预约天数
    self.dayLbl = [UILabel labelWithFrame:CGRectZero
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:kClearColor
                                     font:Font(13)
                                textColor:kTextColor];
    
    [self addSubview:self.dayLbl];
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.equalTo(@80);
        make.bottom.equalTo(@(-10));
    }];
    //昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoIV.mas_right).offset(10);
        make.top.equalTo(@15);
        make.width.lessThanOrEqualTo(@150);
        make.height.equalTo(@(kFontHeight(13.0)));
    }];
    //预约开始时间
    [self.startDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(10);
    }];
    //预约天数
    [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.startDateLbl.mas_bottom).offset(10);
    }];
}

- (void)setOrder:(AppointmentOrderModel *)order {
    
    _order = order;
    
    AppointmentUser *user = order.user;
    //
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[user.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    //
    self.nickNameLbl.text = user.realName;
    //
    self.startDateLbl.text = [order.appointDatetime convertDate];
    //
    self.dayLbl.text = [NSString stringWithFormat:@"%ld天",order.appointDays];
}

- (void)setAchievementOrder:(AchievementOrderModel *)achievementOrder {
    
    _achievementOrder = achievementOrder;
    
    MryUser *user = achievementOrder.mryUser;
    //
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[user.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    //
    self.nickNameLbl.text = user.realName;
    //
    self.startDateLbl.text = [achievementOrder.appointDatetime convertDate];
    //
    self.dayLbl.text = [NSString stringWithFormat:@"%ld天",achievementOrder.appointDays];
    
}
@end
