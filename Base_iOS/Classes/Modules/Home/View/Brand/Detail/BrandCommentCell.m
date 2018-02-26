//
//  BrandCommentCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandCommentCell.h"
//Macro
//Framework
//Category
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "NSString+Date.h"
//Extension
//M
//V
#import "LinkLabel.h"
//C

@interface BrandCommentCell()
//头像
@property (nonatomic, strong) UIImageView *photoIV;
//昵称
@property (nonatomic, strong) UILabel *nameLbl;
//评分
@property (nonatomic, strong) UIView *starView;
//时间
@property (nonatomic, strong) UILabel *timeLbl;
//评论
@property (nonatomic, strong) LinkLabel *contentLbl;

@end

@implementation BrandCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //头像
    CGFloat photoW = 32;
    
    self.photoIV = [[UIImageView alloc] init];
    self.photoIV.layer.cornerRadius = photoW/2.0;
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = kClearColor;
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.photoIV];

    //昵称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kWhiteColor
                                      font:Font(14)
                                 textColor:kTextColor];
    [self addSubview:self.nameLbl];
    //评分
    self.starView = [[UIView alloc] init];
    
    [self addSubview:self.starView];
    //时间
    self.timeLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor whiteColor]
                                      font:Font(12)
                                 textColor:[UIColor colorWithHexString:@"#b4b4b4"]];
    [self addSubview:self.timeLbl];
    //评论
    self.contentLbl = [[LinkLabel alloc] initWithFrame:CGRectZero];
    self.contentLbl.font = Font(15.0);
    self.contentLbl.textColor = [UIColor textColor];
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

- (void)setSubviewLayout {
    
    CGFloat photoW = 32;
    CGFloat leftMargin = 15;
    //头像
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(photoW));
    }];
    //昵称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_top).offset(6);
        make.left.equalTo(self.photoIV.mas_right).offset(leftMargin);
    }];
    //评分
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.photoIV.mas_bottom).offset(0);
    }];
    //时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoIV.mas_centerY).offset(5);
        make.right.equalTo(@(-leftMargin));
    }];
    //评论
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        make.width.equalTo(@(kScreenWidth - 3*15 - photoW));
        make.top.equalTo(self.timeLbl.mas_bottom).offset(10);
    }];
    
    //星星
    for (int i = 0; i < 5; i++) {

        CGFloat x = i*15;
        CGFloat w = 10;

        UIImageView *iv = [[UIImageView alloc] init];

        iv.image = i < _comment.score ? kImage(@"big_star_select"): kImage(@"big_star_unselect");

        [self.starView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(@(x));
            make.width.height.equalTo(@(w));
            make.centerY.equalTo(@0);
        }];
    }
}

#pragma mark - Setting
- (void)setComment:(CommentModel *)comment {
    
    _comment = comment;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[comment.photo convertImageUrl]]
                    placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.nameLbl.text = comment.nickname;
    
    self.timeLbl.text = [comment.commentDatetime convertToDetailDate];
    
    self.contentLbl.text = comment.content;
    //
    [self setSubviewLayout];
    //
    [self layoutSubviews];
    
    comment.commentHeight = self.contentLbl.yy + 10;
}

@end
