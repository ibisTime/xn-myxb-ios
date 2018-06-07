//
//  TripListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TripListCell.h"

#define kHeadIconWidth 60
//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>

#import "TLUser.h"

@interface TripListCell()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//星期
@property (nonatomic, strong) UILabel *weekLbl;
//日期
@property (nonatomic, strong) UILabel *dateLbl;
//时间
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UILabel *type;


@end

@implementation TripListCell

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
    
    self.photoIV.layer.cornerRadius = kHeadIconWidth/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = [UIColor clearColor];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoIV];
    //星期
//    self.weekLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                           textColor:kTextColor
//                                                font:13.0];
//    [self addSubview:self.dateLbl];
    //日期
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:13.0];
    [self addSubview:self.dateLbl];
    //时间
//    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                           textColor:kTextColor
//                                                font:13.0];
//    [self addSubview:self.dateLbl];
    
    //日期
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:13.0];
    [self addSubview:self.timeLbl];
    
    
    //日期
    self.type = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kThemeColor
                                                font:15.0];
    [self addSubview:self.type];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat leftMargin = 15;
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(10));
        make.width.height.equalTo(@(kHeadIconWidth));
    }];
    //星期
//    [self.weekLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.photoIV.mas_top).offset(3);
//        make.left.equalTo(self.photoIV.mas_right).offset(12);
//    }];
    
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.photoIV.mas_top);
        make.height.equalTo(@15);
    }];
//    //日期
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoIV.mas_right).offset(12);
        make.centerY.equalTo(@0);
    }];
//    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.photoIV.mas_right).offset(12);
        make.top.equalTo(self.dateLbl.mas_bottom).offset(6);
    }];
}

#pragma mark - Setting
- (void)setTrip:(TripListModel *)trip {
    
    _trip = trip;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];

    NSString *startDate = [trip.startDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endDate = [trip.endDatetime convertDateWithFormat:@"yyyy-MM-dd HH:mm"];
    
    self.dateLbl.text = startDate;//[NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    self.timeLbl.text = endDate;
    if ([trip.type integerValue] == 1) {
        self.type.text = @"可预约";
    }
    else
    {
        self.type.text = @"可调配时间";

    }
}

@end
