//
//  RankingListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "RankingListCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"

#define kAmountBtnHeight 30

@interface RankingListCell()
//排名
@property (nonatomic, strong) UIButton *rankBtn;
//头像
@property (nonatomic, strong) UIImageView *iconIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//金额
@property (nonatomic, strong) UIButton *amountBtn;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation RankingListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.isFirst = NO;
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.contentView.backgroundColor = kWhiteColor;
    //排名
    self.rankBtn = [UIButton buttonWithTitle:@""
                                  titleColor:kTextColor
                             backgroundColor:kClearColor
                                   titleFont:14.0];
    
    [self.contentView addSubview:self.rankBtn];
    
    
    //头像
    self.iconIV = [[UIImageView alloc] initWithImage:kImage(@"头像")];
    
    [self.contentView addSubview:self.iconIV];
    
    //昵称
    self.nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    //根据label宽度自动调节字体大小
    self.nickNameLbl.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.nickNameLbl];
    //金额
    self.amountBtn = [UIButton buttonWithTitle:@""
                                    titleColor:kTextColor
                               backgroundColor:kClearColor
                                     titleFont:15.0
                                  cornerRadius:kAmountBtnHeight/2.0];
    
    [self.contentView addSubview:self.amountBtn];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setSubviewMasonry {
    //排名
    [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    //头像
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rankBtn.mas_right).offset(0);
        make.centerY.equalTo(@0);
        make.height.width.equalTo(@40);
        
    }];
    //金额
    CGFloat width = [NSString getWidthWithString:self.amountBtn.titleLabel.text font:15.0]+20;
    
    [self.amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.width.equalTo(@(width));
        make.right.equalTo(@(-15));
        make.height.equalTo(@(kAmountBtnHeight));
        
    }];
    
    //昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconIV.mas_right).offset(10);
        make.right.equalTo(self.amountBtn.mas_left).offset(-10);
        
    }];

    self.isFirst = YES;
}

#pragma mark - Data
- (void)setRanking:(RankingModel *)ranking {
    
    _ranking = ranking;
    
    //排行
    if (ranking.rank <= 3) {
        
        [self.rankBtn setImage:kImage(ranking.rankImg) forState:UIControlStateNormal];
        
        [self.rankBtn setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [self.rankBtn setImage:nil forState:UIControlStateNormal];
        
        [self.rankBtn setTitle:[NSString stringWithFormat:@"%ld", ranking.rank] forState:UIControlStateNormal];
    }
    
    //头像
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[ranking.photo convertImageUrl]]
                   placeholderImage:kImage(@"头像")];
    //昵称
    self.nickNameLbl.text = ranking.name;
    //金额
    NSString *amount = [NSString stringWithFormat:@"￥%@", [ranking.amount convertToRealMoney]];

    [self.amountBtn setTitle:amount forState:UIControlStateNormal];
    
    if (!_isFirst) {
        
        [self setSubviewMasonry];
    }
}

@end
