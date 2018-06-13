//
//  QRCodeView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QRCodeView.h"
//Category
#import "NSString+Date.h"


//
//#import "SGQRCodeTool.h"

@interface QRCodeView()

//背景
@property (nonatomic, strong) UIView *bgView;
//确认按钮
@property (nonatomic, strong) UIButton *confirmBtn;
//二维码
@property (nonatomic, strong) UIImageView *qrCodeIV;

@end

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat bgW = kScreenWidth - 2*kWidth(35);

    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithUIColor:kBlackColor
                                               alpha:0.6];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgW, 0)];
    
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    
    //档期时间
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kThemeColor
                                                    font:16.0];
    textLbl.text = @"扫描二维码";
    textLbl.frame = CGRectMake(0, 35, self.bgView.width, 16);
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.bgView addSubview:textLbl];
    
    CGFloat qrViewW = kScreenWidth - kWidth(110);
    
    self.qrCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,textLbl.yy + kWidth(20), qrViewW, qrViewW)];
    
    self.qrCodeIV.centerX = self.bgView.width/2.0;
    
    [self.bgView addSubview:self.qrCodeIV];
    
    UILabel *textLbl2 = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:14.0];
    
    textLbl2.text = @"扫描上面的二维码, 邀请好友";
    
    textLbl2.textAlignment = NSTextAlignmentCenter;
    
    textLbl2.frame = CGRectMake(0, self.qrCodeIV.yy + kWidth(20), self.bgView.width, 15.0);
    
    [self.bgView addSubview:textLbl2];
    //我知道了
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"取消"
                                          titleColor:kWhiteColor
                                     backgroundColor:kThemeColor
                                           titleFont:14.0
                                        cornerRadius:5];
    
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn.frame = CGRectMake((bgW - kWidth(250))/2.0, textLbl2.yy + 30, kWidth(250), 35);

    [self.bgView addSubview:confirmBtn];
    
    self.confirmBtn = confirmBtn;
    
    CGFloat bgH = self.confirmBtn.yy + 35;
    
    self.bgView.height = bgH;
    self.bgView.center = self.center;
}

#pragma mark - Setting
- (void)setUrl:(NSString *)url {
    
    _url = url;
    
//    UIImage *image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:url
//                                                     imageViewWidth:kScreenWidth];
//    self.qrCodeIV.image = image;
    
    [self.qrCodeIV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

#pragma mark - Events
- (void)confirm {
    
    [self hide];
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
