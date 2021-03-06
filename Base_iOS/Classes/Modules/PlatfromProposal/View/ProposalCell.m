//
//  ProposalCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ProposalCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "AppMacro.h"
//Category
#import "NSString+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import <UIImageView+WebCache.h>
#import "UILabel+Extension.h"

@interface ProposalCell()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nickNameLbl;
//日期
@property (nonatomic, strong) UILabel *dateLbl;
//评分
@property (nonatomic, strong) UIView *starView;
//内容
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation ProposalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    CGFloat headIconH = 32;
    //头像
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.layer.cornerRadius = headIconH/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = [UIColor clearColor];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoIV];
    //昵称
    self.nickNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:13.0];
    
    [self addSubview:self.nickNameLbl];
    //日期
    self.dateLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:11.0];
    [self addSubview:self.dateLbl];
    //评分
    self.starView = [[UIView alloc] init];
    
    [self addSubview:self.starView];
    //内容
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:13.0];
    self.contentLbl.numberOfLines = 0;
    
    [self addSubview:self.contentLbl];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setSubViewLayout {
    
    CGFloat leftMargin = 15;
    CGFloat headIconH = 32;

    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(headIconH));
    }];
    //昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_top).offset(2);
        make.left.equalTo(self.photoIV.mas_right).offset(12);
    }];
    //日期
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.nickNameLbl.mas_top);
    }];
    //评分
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_left);
        make.top.equalTo(self.nickNameLbl.mas_bottom).offset(8);
    }];
    //内容
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.right.equalTo(@(-leftMargin));
        make.top.equalTo(self.photoIV.mas_bottom).offset(10);
    }];
}

- (void)setProposal:(ProposalModel *)proposal {
    
    _proposal = proposal;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[proposal.photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    self.nickNameLbl.text = proposal.realName;
    self.dateLbl.text = [proposal.commentDatetime convertToDetailDate];
    //
    NSInteger index = proposal.score;
    
    [self.starView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperview];
    }];
    
    for (int i = 0; i < 5; i++) {
        
        CGFloat x = i*15;
        CGFloat w = 10;
        
        UIImageView *iv = [[UIImageView alloc] init];
        
        iv.image = i < index ? kImage(@"big_star_select"): kImage(@"big_star_unselect");
        
        [self.starView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
    }
    
    STRING_NIL_NULL(proposal.content);
    [self.contentLbl labelWithTextString:proposal.content lineSpace:5];
    
    [self setSubViewLayout];
    //
    [self layoutSubviews];
    
    CGFloat h = [proposal.content valid] ? 15: 5;
    
    proposal.cellHeight = self.contentLbl.yy + h;

}

@end
