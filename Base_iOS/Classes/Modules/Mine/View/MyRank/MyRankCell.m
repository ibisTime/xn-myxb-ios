//
//  MyRankCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyRankCell.h"
//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import "NSString+CGSize.h"
#import <UIImageView+WebCache.h>
#import "TLUser.h"

#define kHeadIconWidth 60

@interface MyRankCell()
//排名
//头像
//昵称
//金额
//排名
@property (nonatomic, strong) UIButton *rankBtn;
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//金额
@property (nonatomic, strong) UILabel *amountLbl;

@end

@implementation MyRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
 
    //排名
    self.rankBtn = [UIButton buttonWithTitle:@""
                                  titleColor:kTextColor
                             backgroundColor:kClearColor
                                   titleFont:14.0];
    
    [self addSubview:self.rankBtn];
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
                                                    font:14.0];
    
    [self addSubview:self.nickNameLbl];
    //金额
    self.amountLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:14.0];
    self.amountLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.amountLbl];
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
}

- (void)setSubviewLayout {
    
    //排名
    [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rankBtn.mas_right);
        make.centerY.equalTo(@0);
        make.height.width.equalTo(@(kHeadIconWidth));
        
    }];
    //金额
    CGFloat width = [NSString getWidthWithString:self.amountLbl.text font:15.0]+20;
    
    [self.amountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.width.equalTo(@(width));
        make.right.equalTo(@(-15));
    }];
    
    //昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(self.photoIV.mas_right).offset(10);
        make.right.equalTo(self.amountLbl.mas_left).offset(-10);
    }];
}

#pragma mark - Setting
- (void)setRank:(MyRankModel *)rank {
    
    _rank = rank;
    //排行
    if (rank.rank <= 3) {
        
        [self.rankBtn setImage:kImage(rank.rankImg) forState:UIControlStateNormal];
        
        [self.rankBtn setTitle:@"" forState:UIControlStateNormal];

    } else {
        
        [self.rankBtn setImage:nil forState:UIControlStateNormal];

        [self.rankBtn setTitle:[NSString stringWithFormat:@"%ld", rank.rank] forState:UIControlStateNormal];
    }
    //头像
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]]
                   placeholderImage:kImage(@"头像")];
    //昵称
    self.nickNameLbl.text = rank.name;
    //金额
    NSString *amount = [NSString stringWithFormat:@"￥%@", rank.amount];
    
    self.amountLbl.text = amount;
    
    [self setSubviewLayout];

}

@end
