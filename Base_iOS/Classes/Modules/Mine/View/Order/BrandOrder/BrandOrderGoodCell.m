//
//  BrandOrderGoodCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BrandOrderGoodCell.h"

//Category
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"
#import "NSString+Date.h"
#import "UIButton+EnLargeEdge.h"
#import "UIControl+Block.h"

@interface BrandOrderGoodCell()

@property (nonatomic, strong) UIImageView *coverIV;

@property (nonatomic, strong) UILabel *nameLbl;
//商品价格
@property (nonatomic, strong) UILabel *priceLbl;
//数目
@property (nonatomic, strong) UILabel *numLbl;
//总价
@property (nonatomic, strong) UILabel *totalAmountLbl;
//下单时间
@property (nonatomic, strong) UILabel *timeLbl;

@property (nonatomic, strong) UIButton *cancelOrder;

@property (nonatomic, strong)UIView *lineview;

@end

@implementation BrandOrderGoodCell

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
    //下单时间
    self.timeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                           textColor:kTextColor2
                                                font:12.0];
    
    [self addSubview:self.timeLbl];
    
    
    self.lineview = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineview.backgroundColor = kLineColor;
    [self addSubview:self.lineview];
    
    BaseWeakSelf;
    self.cancelOrder = [UIButton buttonWithTitle:@"取消订单"
                                      titleColor:kWhiteColor
                                 backgroundColor:kThemeColor
                                       titleFont:18.0];
    
    
    [self.cancelOrder bk_addEventHandler:^(id sender) {
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cancelOrderWithIndexpath:)]) {
            [weakSelf.delegate cancelOrderWithIndexpath:weakSelf.indexpath];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelOrder.layer.cornerRadius = 4;
    [self addSubview:self.cancelOrder];
    
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
        make.width.equalTo(@90);
        make.height.equalTo(@90);
        
    }];
    //价格
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
        make.width.lessThanOrEqualTo(@(kWidth(130)));
        make.height.equalTo(@(kFontHeight(13.0)));
    }];
    //名称
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.coverIV.mas_right).offset(10);
        make.right.equalTo(self.priceLbl.mas_left).offset(-15);
        make.top.equalTo(@15);
        make.height.lessThanOrEqualTo(@(60));
        
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
        make.width.lessThanOrEqualTo(@(kWidth(150)));
        make.height.equalTo(@(kFontHeight(14.0)));
        make.bottom.equalTo(self.coverIV.mas_bottom);
    }];
    //下单时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nameLbl.mas_left);
        make.bottom.equalTo(self.coverIV.mas_bottom);
    }];
    
    
    
}

- (void)setOrder:(BrandOrderModel *)order {
    
    _order = order;
    
    if ([order.status integerValue] == 0) {
        
        self.lineview.hidden = NO;
        self.cancelOrder.hidden = NO;
        
        
        [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLbl.mas_bottom).with.offset(10);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@.7);
        }];
        [self.cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineview.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.width.equalTo(@100);
        }];
    }
    else
    {
        self.lineview.hidden = YES;
        self.cancelOrder.hidden = YES;
    }
    
    //
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[order.detailModel.product[@"advPic"] convertImageUrl]] placeholderImage:GOOD_PLACEHOLDER_SMALL];
    //
    self.nameLbl.text = order.detailModel.product[@"name"];
    //
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", [_order.detailModel.price convertToRealMoney]];
    //
    self.numLbl.text = [NSString stringWithFormat:@"X %@",[order.detailModel.quantity stringValue]];
    //
    self.timeLbl.text = [order.applyDatetime convertDate];
    //总计=(商品总额+运费)*折扣
    // + [_order.yunfei doubleValue]
    CGFloat totalAmount = [_order.amount doubleValue];
    NSString *amountStr = [NSString stringWithFormat:@"%@", [@(totalAmount) convertToRealMoney]];
    [_totalAmountLbl labelWithString:[NSString stringWithFormat:@"总计: %@", amountStr] title:amountStr font:Font(15.0) color:kThemeColor];
}

@end
