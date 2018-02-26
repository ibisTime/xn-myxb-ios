//
//  BrandCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandCell.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
//Extension
#import <UIImageView+WebCache.h>
//M
//V
//C
@interface BrandCell()

//image
@property (nonatomic, strong) UIImageView *goodIV;
//title
@property (nonatomic, strong) UILabel *nameLbl;

@end

@implementation BrandCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat imgW = (kScreenWidth - 10)/2.0;
    
    self.goodIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgW)];
    
    self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
    self.goodIV.clipsToBounds = YES;
    
    [self addSubview:self.goodIV];
    
    //名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero textAligment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor] font:Font(14.0) textColor:kTextColor];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.goodIV.mas_bottom).offset(10);
        make.width.equalTo(@(imgW - 20));
    }];
}

#pragma mark - Setting
- (void)setBrandModel:(BrandModel *)brandModel {
    
    _brandModel = brandModel;
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:brandModel.advPic] placeholderImage:GOOD_PLACEHOLDER_SMALL];

    _nameLbl.text = brandModel.name;

}

@end
