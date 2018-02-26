//
//  IntegralExchangeView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralExchangeView.h"

//Macro
//Category
//Extension
//M
//V
//地址
//姓名
//手机号
@interface IntegralExchangeView()

//背景
@property (nonatomic, strong) UIView *bgView;
//兑换按钮
@property (nonatomic, strong) UIButton *exchangeBtn;

@end

@implementation IntegralExchangeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor alpha:0.6];
    
    //背景
    CGFloat bgW = kScreenWidth - 2*kWidth(35);
    CGFloat bgH = 276;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(kWidth(35), kWidth(173), bgW, bgH)];
    
    self.bgView.backgroundColor = kWhiteColor;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    
    //档期时间
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kThemeColor font:16.0];
    
    textLbl.text = @"积分兑换";
    
    [self.bgView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@30);
    }];
    //icon
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"积分兑换")];
    
    [self.bgView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(textLbl.mas_left).offset(-15);
        make.centerY.equalTo(textLbl.mas_centerY);
    }];
    
    CGFloat leftMargin = 15;
    CGFloat leftW = 10;
    CGFloat margin = 10;
    CGFloat tfH = 34;
    CGFloat tfW = bgW - 2*leftMargin;
    //地址
    self.addressTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, 70, tfW, tfH) leftTitle:@"" titleWidth:leftW placeholder:@"请选择地址"];
    
    self.addressTF.layer.borderColor = kLineColor.CGColor;
    self.addressTF.layer.borderWidth = 0.5;
    self.addressTF.layer.cornerRadius = 5;
    self.addressTF.clipsToBounds = YES;
    self.addressTF.font = Font(11.0);

    [self.bgView addSubview:self.addressTF];
    //点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress)];
    
    [self.addressTF addGestureRecognizer:tapGR];
    //右箭头
    CGFloat arrowW = 6;
    CGFloat arrowH = 10;
    CGFloat rightMargin = 10;
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    arrowIV.frame = CGRectMake(tfW - rightMargin - arrowW, 0, arrowW, arrowH);
    arrowIV.centerY = tfH/2.0;
    
    [self.addressTF addSubview:arrowIV];
    
    //姓名
    self.nameTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, self.addressTF.yy + margin, tfW, tfH) leftTitle:@"" titleWidth:leftW placeholder:@"请输入姓名"];
    
    self.nameTF.layer.borderColor = kLineColor.CGColor;
    self.nameTF.layer.borderWidth = 0.5;
    self.nameTF.layer.cornerRadius = 5;
    self.nameTF.clipsToBounds = YES;
    self.nameTF.font = Font(11.0);
    
    [self.bgView addSubview:self.nameTF];
    //手机号
    self.mobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(leftMargin, self.nameTF.yy + margin, tfW, tfH) leftTitle:@"" titleWidth:leftW placeholder:@"请输入手机号码"];
    
    self.mobileTF.layer.borderColor = kLineColor.CGColor;
    self.mobileTF.layer.borderWidth = 0.5;
    self.mobileTF.layer.cornerRadius = 5;
    self.mobileTF.clipsToBounds = YES;
    self.mobileTF.font = Font(11.0);
    
    self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.bgView addSubview:self.mobileTF];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:kTextColor backgroundColor:kPaleGreyColor titleFont:16.0 cornerRadius:5];
    
    [cancelBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.frame = CGRectMake(leftMargin, self.mobileTF.yy + 20, kWidth(125), 35);
    
    [self.bgView addSubview:cancelBtn];
    //兑换
    UIButton *exchangeBtn = [UIButton buttonWithTitle:@"兑换"
                                           titleColor:kWhiteColor
                                      backgroundColor:kThemeColor
                                            titleFont:16.0
                                         cornerRadius:5];
    
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
    exchangeBtn.frame = CGRectMake(bgW - kWidth(125) - leftMargin, cancelBtn.y, kWidth(125), 35);
    
    [self.bgView addSubview:exchangeBtn];
    
    self.exchangeBtn = exchangeBtn;
}

#pragma mark - Setting

#pragma mark - Events
- (void)exchange {
    
    [self hide];
    
    if (_exchangeBlock) {
        
        _exchangeBlock(ExchangeTyepExchange);
    }
}

- (void)selectAddress {
    
    [self hide];

    if (_exchangeBlock) {
        
        _exchangeBlock(ExchangeTyepSelectAddress);
    }
}

- (void)cancel {
    
    [self hide];
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
