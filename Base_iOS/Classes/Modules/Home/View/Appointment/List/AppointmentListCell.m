//
//  AppointmentListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentListCell.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSString+Check.h"
#import "UILabel+Extension.h"
#import <UIImageView+WebCache.h>

#define kHeadIconWidth 80

@interface AppointmentListCell()

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

@property (nonatomic, strong) UILabel *leveLbl;

//评分
@property (nonatomic, strong) UIView *starView;
//个人简介
@property (nonatomic, strong) UILabel *introduceLbl;
//状态
@property (nonatomic, strong) UIButton *statusBtn;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation AppointmentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    
    self.leveLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kThemeColor
                                                     font:13.0];
    [self addSubview:self.leveLbl];
    //评分
    self.starView = [[UIView alloc] init];
    
    [self addSubview:self.starView];
    //个人简介
    self.introduceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:13.0];
    self.introduceLbl.numberOfLines = 0;
    
    [self addSubview:self.introduceLbl];
    //状态
    self.statusBtn = [UIButton buttonWithTitle:@"可预约"
                                    titleColor:kWhiteColor
                               backgroundColor:kAppCustomMainColor
                                     titleFont:12.0
                                  cornerRadius:12.5];
    self.statusBtn.enabled = NO;
    
    [self addSubview:self.statusBtn];
    
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
   
    //个人简介
    [self.introduceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.photoIV.mas_bottom).offset(18);
    }];
    //状态
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.photoIV.mas_top);
        make.width.equalTo(@65);
        make.height.equalTo(@24);
    }];
    
    __block CGFloat x = kHeadIconWidth + 30;
    __block CGFloat y = 6;
    
    //风格
    
    [self.appointmentModel.styles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj valid]) {
            
            return ;
        }
        
        CGFloat w = [NSString getWidthWithString:obj font:11.0] + 10;
        
        CGFloat xx = x + w + 10;
        
        if (xx > kScreenWidth) {
            
            y += 23;
            x = kHeadIconWidth + 30;
        }
        
        UIColor *titleColor = kAppCustomMainColor;
        
        UIButton *btn = [UIButton buttonWithTitle:obj
                                       titleColor:titleColor
                                  backgroundColor:kWhiteColor
                                        titleFont:11.0
                                     cornerRadius:8.5];
        
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = titleColor.CGColor;
        
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.top.equalTo(self.jobLbl.mas_bottom).offset(y);
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
        
//        iv.image = i < [_appointmentModel.level integerValue] ? kImage(@"big_star_select"): kImage(@"big_star_unselect");
        
        [self.starView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
    }
    
    //评分
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.jobLbl.mas_bottom).offset(y + 23 + 6);
    }];
    
    [self.leveLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.jobLbl.mas_bottom).offset(y + 23 + 6);
        
        
    }];
    _isFirst = YES;
}

#pragma mark - Setting
- (void)setAppointmentModel:(AppointmentListModel *)appointmentModel {
    
    _appointmentModel = appointmentModel;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[appointmentModel.photo convertImageUrl]]
                    placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nickNameLbl.text = appointmentModel.realName;
    
    self.genderIV.image = [appointmentModel.gender isEqualToString:@"0"] ?  kImage(@"男士"): kImage(@"女生");
    
    self.jobLbl.text = [appointmentModel getUserType];
    
    self.expertiseLbl.text = [appointmentModel.speciality valid] ?
    [NSString stringWithFormat:@"专长: %@", appointmentModel.speciality]: @"";
    
    if ([appointmentModel.level isEqualToString:@"zs_spec"]) {
        self.leveLbl.text = @"资深";

    }
    else
    {
        self.leveLbl.text = @"初级";

    }
    
    [self.introduceLbl labelWithTextString:appointmentModel.slogan lineSpace:5];
    //布局
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    appointmentModel.cellHeight = self.introduceLbl.yy + 15;
}

@end
