//
//  GoodNewsCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "GoodNewsCell.h"
#define kHeadIconWidth 60
//Category
#import "NSString+Date.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>

#import "TLUser.h"

@interface GoodNewsCell()

//缩略图
@property (nonatomic, strong) UIImageView *photoIV;
//标题
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation GoodNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //缩略图
    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.layer.masksToBounds = YES;
    self.photoIV.backgroundColor = [UIColor clearColor];
    self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.photoIV];
    //日期
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor
                                                font:13.0];
    self.titleLbl.numberOfLines = 0;
    
    [self addSubview:self.titleLbl];
    
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
    //缩略图
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(leftMargin));
        make.top.equalTo(@(10));
        make.width.height.equalTo(@(kHeadIconWidth));
    }];
    //标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoIV.mas_right).offset(12);
        make.centerY.equalTo(@0);
    }];

}

#pragma mark - Setting
- (void)setNews:(GoodNewsModel *)news {
    
    _news = news;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[news.pic convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
     self.titleLbl.text = news.title;
    
}

@end
