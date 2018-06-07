//
//  ResultsView.m
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ResultsView.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "NSString+Date.h"

@interface ResultsView ()
@property (nonatomic , strong)AppointmentOrderModel *order;
@end
@implementation ResultsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withOrder:(AppointmentOrderModel *)order
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.order = order;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    v.backgroundColor = [UIColor whiteColor];
    [self addSubview:v];
    
    UILabel *lbl1 = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:Font(11)
                                  textColor:kTextColor2];
    [v addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v.mas_left).offset(15);
        make.top.equalTo(v.mas_top).offset(10);
        make.bottom.equalTo(v.mas_bottom);
    }];
    lbl1.text = [NSString stringWithFormat:@"订单编号: %@", self.order.code];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height - 0.7, kScreenWidth, 0.7)];
    line.backgroundColor = kLineColor;
    [v addSubview:line];
    
    //头像
    UIImageView *photoIV = [[UIImageView alloc] init];
    
    photoIV.contentMode = UIViewContentModeScaleAspectFill;
    photoIV.clipsToBounds = YES;
    photoIV.layer.cornerRadius = 40;
    
    [self addSubview:photoIV];
    
    //昵称
    UILabel *nickNameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:Font(13.0)
                                     textColor:kThemeColor];
    [self addSubview:nickNameLbl];
    
    //预约开始时间
    UILabel *startDateLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:kClearColor
                                           font:Font(15.0)
                                      textColor:kTextColor];
    
    startDateLbl.numberOfLines = 0;
    
    [self addSubview:startDateLbl];
    
    //预约天数
    UILabel *dayLbl = [UILabel labelWithFrame:CGRectZero
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:kClearColor
                                     font:Font(13)
                                textColor:kThemeColor];
    
    [self addSubview:dayLbl];
    dayLbl.text = [self.order getStatusName];
    //
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = kLineColor;
    [self addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    AppointmentUser *user = self.order.user;

    
    [photoIV sd_setImageWithURL:[NSURL URLWithString:[user.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    //
    nickNameLbl.text = user.realName;
    //
    startDateLbl.text = [self.order.appointDatetime convertDate];
    
    //头像
    [photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(v.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
    }];
    //昵称
    [nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(photoIV.mas_right).offset(10);
        make.top.equalTo(v.mas_bottom).with.offset(15);
        make.height.equalTo(@(kFontHeight(13.0)));
    }];
    //预约开始时间
    [startDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nickNameLbl.mas_left);
        make.top.equalTo(nickNameLbl.mas_bottom).offset(10);
    }];
    //预约天数
    [dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nickNameLbl.mas_left);
        make.top.equalTo(startDateLbl.mas_bottom).offset(10);
    }];
    
}



@end
