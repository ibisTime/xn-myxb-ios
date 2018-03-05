//
//  RankingHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RankingHeaderView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

#define kAmountBtnHeight 30
#define kFirstIVWidth kWidth(80)
#define kSecondIVWidth kWidth(60)

@interface RankingHeaderView()

@end

@implementation RankingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    UIImageView *firstIV;
    
    CGFloat margin = (kScreenWidth - kFirstIVWidth - 2*kSecondIVWidth)/4.0;
    
    CGFloat nameW = kScreenWidth/3.0 - 5;
    
    for (int i = 0; i < 3; i++) {
        
        RankingModel *ranking = self.rankingList[i];
        
        CGFloat width = i == 0 ? kFirstIVWidth: kSecondIVWidth;
        CGFloat rowW = kWidth(16.5);
        //头像
        UIImageView *iconIV = [[UIImageView alloc] init];
        
        iconIV.layer.cornerRadius = width/2.0;
        iconIV.clipsToBounds = YES;
        
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[ranking.photo convertImageUrl]]
                  placeholderImage:kImage(@"头像")];
        
        [self addSubview:iconIV];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@(width));
            if (i == 0) {
                
                make.top.equalTo(@(30));
                make.centerX.equalTo(@0);

            } else if (i == 1) {
                
                make.left.equalTo(@(margin));
                make.centerY.equalTo(firstIV.mas_centerY).offset(0);

            } else {
                
                make.right.equalTo(@(-margin));
                make.centerY.equalTo(firstIV.mas_centerY).offset(0);
            }
        }];
        
        if (i == 0) {
            
            firstIV = iconIV;
        }
        
        //排行
        UIButton *rowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        rowBtn.contentMode = UIViewContentModeScaleAspectFit;
        
        switch (i) {
            case 0:
            {
                [rowBtn setBackgroundImage:kImage(@"第一名") forState:UIControlStateNormal];
            }break;
                
            case 1:
            {
                [rowBtn setBackgroundImage:kImage(@"第二名") forState:UIControlStateNormal];
            }break;
                
            case 2:
            {
                [rowBtn setBackgroundImage:kImage(@"第三名") forState:UIControlStateNormal];
            }break;
                
            default:
                break;
        }
        
        [self addSubview:rowBtn];
        [rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(iconIV.mas_top).offset(0);
            make.centerX.equalTo(iconIV.mas_centerX).offset(0);
        }];
        //金额
        UIButton *amountBtn = [UIButton buttonWithTitle:@""
                                             titleColor:kTextColor
                                        backgroundColor:kClearColor
                                              titleFont:18.0
                                           cornerRadius:kAmountBtnHeight/2.0];
        
        NSString *amount = [NSString stringWithFormat:@"￥%@", [ranking.amount convertToSimpleRealMoney]];

        [amountBtn setTitle:amount forState:UIControlStateNormal];
        
        [self addSubview:amountBtn];
        
        CGFloat amountW = [NSString getWidthWithString:amountBtn.titleLabel.text font:18.0]+20;

        [amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(@(-20));
            make.centerX.equalTo(iconIV.mas_centerX).offset(0);
            make.width.equalTo(@(amountW));
            make.height.equalTo(@(kAmountBtnHeight));
        }];
        
        //昵称
        UILabel *nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:18.0];
        //根据label宽度自动调节字体大小
        nickNameLbl.adjustsFontSizeToFitWidth = YES;
        nickNameLbl.text = ranking.name;
        nickNameLbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:nickNameLbl];
        [nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(amountBtn.mas_top).offset(-10);
            make.centerX.equalTo(iconIV.mas_centerX).offset(0);
            make.width.equalTo(@(nameW));
            
        }];
        
    }
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kWhiteColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

#pragma mark - Setting
- (void)setRankingList:(NSArray<RankingModel *> *)rankingList {
    
    _rankingList = rankingList;
    
    [self initSubviews];
}
@end
