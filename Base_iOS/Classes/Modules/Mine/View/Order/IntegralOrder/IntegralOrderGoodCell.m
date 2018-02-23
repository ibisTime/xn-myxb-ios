//
//  IntegralOrderGoodCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralOrderGoodCell.h"

//Category
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>

@interface IntegralOrderGoodCell()

@property (nonatomic,strong) UIImageView *coverIV;

@property (nonatomic,strong) UILabel *nameLbl;
//商品价格
@property (nonatomic,strong) UILabel *priceLbl;
//数目
@property (nonatomic,strong) UILabel *numLbl;
//总价
@property (nonatomic, strong) UILabel *totalAmountLbl;

@end

@implementation IntegralOrderGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
 
    self.coverIV = [[UIImageView alloc] init];
    
    self.coverIV.contentMode = UIViewContentModeScaleAspectFill;
    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 2;
    self.coverIV.layer.borderWidth = 0.5;
    self.coverIV.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    [self addSubview:self.coverIV];
    
    //价格
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor clearColor]
                                       font:Font(13.0)
                                  textColor:kThemeColor];
    [self addSubview:self.priceLbl];
    
    //名称
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:kClearColor
                                      font:Font(15.0)
                                 textColor:kTextColor];
    
    self.nameLbl.numberOfLines = 0;
    
    [self addSubview:self.nameLbl];
    
    //数量
    self.numLbl = [UILabel labelWithFrame:CGRectZero
                             textAligment:NSTextAlignmentLeft
                          backgroundColor:kClearColor
                                     font:Font(13)
                                textColor:kTextColor];
    
    [self addSubview:self.numLbl];
    //总价
    self.totalAmountLbl = [UILabel labelWithFrame:CGRectZero
                                     textAligment:NSTextAlignmentRight
                                  backgroundColor:kClearColor
                                             font:Font(14.0)
                                        textColor:kTextColor];
    
    [self addSubview:self.totalAmountLbl];
    
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

- (void)setSubviewLayout {
    
    //商品图片
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.equalTo(@80);
        make.bottom.equalTo(@(-10));
    }];
    //名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
        make.height.lessThanOrEqualTo(@(MAXFLOAT));
        
    }];
    //价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
        make.width.lessThanOrEqualTo(@150);
        make.height.equalTo(@(kFontHeight(13.0)));
    }];
    //数量
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.width.lessThanOrEqualTo(@150);
        make.height.equalTo(@(kFontHeight(13.0)));
        make.top.equalTo(self.priceLbl.mas_bottom).offset(6);
    }];
    //总价
    [self.totalAmountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.width.lessThanOrEqualTo(@250);
        make.height.equalTo(@(kFontHeight(14.0)));
        make.bottom.equalTo(@(-15));
    }];
}

- (void)setOrder:(IntegralOrderModel *)order {
    
    _order = order;
    
    IntegralOrderDetailModel *product = _order.productOrderList[0];
//
//    NSString *urlStr = [product.productPic componentsSeparatedByString:@"||"][0];
//
//    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[urlStr convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
//
//    //
//    self.nameLbl.text = product.productName;
//
//    //
//    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_order.amount1 convertToSimpleRealMoney]];
//
//    //
//    self.numLbl.text = [NSString stringWithFormat:@"X %@",[product.quantity stringValue]];
//
//    //
//
//    //总计=(商品总额+运费)*折扣
//
//    CGFloat totalAmount = [_order.amount1 doubleValue] + [_order.yunfei doubleValue];
//
//    NSString *amountStr = [NSString stringWithFormat:@"￥%@", [@(totalAmount) convertToSimpleRealMoney]];
//
//    [_totalAmountLbl labelWithString:[NSString stringWithFormat:@"总计: %@", amountStr] title:amountStr font:Font(15.0) color:kThemeColor];
}

@end
