//
//  BrandOrderDetailCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderDetailCell.h"

//Macro
#import "AppMacro.h"
//Category
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "NSString+Date.h"
@interface BrandOrderDetailCell()
//
@property (nonatomic,strong) UIImageView *coverIV;
//商品价格
@property (nonatomic, strong) UILabel *priceLbl;
//商品名称
@property (nonatomic,strong) UILabel *nameLbl;
//商品描述
@property (nonatomic,strong) UILabel *sloginLbl;
//数目
@property (nonatomic,strong) UILabel *numLbl;

@end

@implementation BrandOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverIV = [[UIImageView alloc] init];
        
        self.coverIV.contentMode = UIViewContentModeScaleAspectFill;
        self.coverIV.clipsToBounds = YES;
        self.coverIV.layer.cornerRadius = 2;
        self.coverIV.layer.borderWidth = 0.5;
        self.coverIV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
        [self addSubview:self.coverIV];
        
        //名称
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:kClearColor
                                          font:Font(15.0)
                                     textColor:kTextColor];
        
        self.nameLbl.numberOfLines = 0;
        
        [self addSubview:self.nameLbl];
        
        //商品描述
        self.sloginLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentLeft
                                 backgroundColor:[UIColor clearColor]
                                            font:Font(13.0)
                                       textColor:kTextColor2];
        
        self.sloginLbl.numberOfLines = 2;
        [self addSubview:self.sloginLbl];
        //价格
        self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:Font(13.0)
                                      textColor:kThemeColor];
        [self addSubview:self.priceLbl];
        
        //数量
        self.numLbl = [UILabel labelWithFrame:CGRectZero
                                 textAligment:NSTextAlignmentLeft
                              backgroundColor:kClearColor
                                         font:Font(13)
                                    textColor:kTextColor];
        
        [self addSubview:self.numLbl];
        
        //
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        //布局
        [self setSubviewLayout];
    }
    return self;
}

- (void)setSubviewLayout {
    
    //商品图片
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.equalTo(@90);
        make.bottom.equalTo(@(-10));
    }];
    //名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
    }];
    //广告语
    [self.sloginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(self.nameLbl.mas_bottom).offset(8);
        make.left.equalTo(self.nameLbl.mas_left);
        make.height.lessThanOrEqualTo(@30);
        
    }];
    //价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.coverIV.mas_bottom);
    }];
    //数量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.bottom.equalTo(self.coverIV.mas_bottom);
    }];
    
}

- (void)setOrder:(BrandOrderModel *)order {
    
    _order = order;
    
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[order.detailModel.product[@"advPic"] convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    //
    self.nameLbl.text = order.detailModel.product[@"name"];
    //
    NSString *slogin = order.detailModel.product[@"slogan"];
    STRING_NIL_NULL(slogin)
    self.sloginLbl.text = slogin;
    //
    self.priceLbl.text = [NSString stringWithFormat:@"%@", [_order.amount convertToRealMoney]];
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[order.detailModel.quantity stringValue]];
    
}
- (void)setCelldata:(NSDictionary *)celldata
{
    _celldata = celldata;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[celldata[@"product"][@"advPic"] convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    //
    self.nameLbl.text = celldata[@"product"][@"name"];
    //
    NSString *slogin = celldata[@"product"][@"slogan"];
    STRING_NIL_NULL(slogin)
    self.sloginLbl.text = slogin;
    //
    
    float price = [celldata[@"price"] integerValue];
    NSNumber *priceNumber = [NSNumber numberWithInteger:price];
    self.priceLbl.text = [NSString stringWithFormat:@"%@", [priceNumber convertToRealMoney]];
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[celldata[@"quantity"] stringValue]];
}

@end
