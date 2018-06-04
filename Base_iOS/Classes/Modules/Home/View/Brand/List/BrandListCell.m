//
//  BrandListCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandListCell.h"
//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
//M
//V
//C

@interface BrandListCell()
//产品图片
@property (nonatomic, strong) UIImageView *goodIV;
//产品名称
@property (nonatomic, strong) UILabel *nameLbl;
//产品说明
@property (nonatomic, strong) UILabel *descLbl;
//产品价格
@property (nonatomic, strong) UILabel *priceLbl;
//产品销量
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation BrandListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    //产品图片
    self.goodIV = [[UIImageView alloc] init];
    
    self.goodIV.contentMode = UIViewContentModeScaleAspectFill;
    self.goodIV.clipsToBounds = YES;
    
    [self addSubview:self.goodIV];
    
    //产品名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    //产品说明
    self.descLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:14.0];
    self.descLbl.numberOfLines = 0;
    
    [self addSubview:self.descLbl];
    //产品价格
    self.priceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                            textColor:kThemeColor
                                                 font:18.0];
    
    [self addSubview:self.priceLbl];
    //产品销量
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor2
                                               font:14.0];
    
    self.numLbl.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.numLbl];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    //布局
    [self setSubviewLayout];
    
}

- (void)setSubviewLayout {

    CGFloat leftMargin = 15;
    
    //产品图片
    [self.goodIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(@(leftMargin));
        make.width.height.equalTo(@(110));
    }];
    //产品名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.goodIV.mas_right).offset(leftMargin);
        make.top.equalTo(self.goodIV.mas_top).offset(8);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@40);
    }];
    //产品说明
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
        make.right.equalTo(@(-leftMargin));
        make.height.lessThanOrEqualTo(@20);
    }];
    //产品价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.goodIV.mas_bottom).offset(-5);
        make.width.lessThanOrEqualTo(@(kWidth(130)));
    }];
    //产品销量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-(leftMargin));
        make.centerY.equalTo(self.priceLbl.mas_centerY);
    }];
}

#pragma mark - Setting
- (void)setBrandModel:(BrandModel *)brandModel {
    
    _brandModel = brandModel;
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:[brandModel.pic convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    _nameLbl.text = brandModel.name;
    _descLbl.text = brandModel.slogan;
    
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [brandModel.price convertToRealMoney]];
    _numLbl.text = [NSString stringWithFormat:@"已售: %ld", brandModel.soldOutCount];
    
}
- (void)setShopModel:(ShopCarModel *)shopModel
{
    _shopModel = shopModel;
    
    [_goodIV sd_setImageWithURL:[NSURL URLWithString:[shopModel.product[@"pic"] convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    
    _nameLbl.text = shopModel.product[@"name"];
    _descLbl.text = shopModel.product[@"slogan"];
    
    _priceLbl.text = [NSString stringWithFormat:@"￥%@", [shopModel.product[@"price"] convertToRealMoney]];
    _numLbl.text = [NSString stringWithFormat:@"X%ld", [shopModel.quantity integerValue]];
}
@end
