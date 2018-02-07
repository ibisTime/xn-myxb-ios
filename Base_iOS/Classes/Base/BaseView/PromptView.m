//
//  PromptView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PromptView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Framework
//Category
//Extension
//M
//V
//C

@interface PromptView()
//
@property (nonatomic, strong) UILabel *titleLbl;
//重新加载
@property (nonatomic, strong) UIButton *reloadBtn;
//图标
@property (nonatomic, strong) UIImageView *iconIV;

@end

@implementation PromptView

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
    
    //图标
    self.iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.iconIV];
    //提示
    self.titleLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:kClearColor
                                       font:Font(15.0)
                                  textColor:kTextColor2];
    [self addSubview:self.titleLbl];
    //重新加载
    self.reloadBtn = [UIButton buttonWithTitle:@""
                                    titleColor:kPaleBlueColor
                               backgroundColor:kClearColor
                                     titleFont:15.0
                                  cornerRadius:5];
    self.reloadBtn.layer.borderWidth = 1;
    self.reloadBtn.layer.borderColor = kPaleBlueColor.CGColor;
    
    [self.reloadBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reloadBtn];
}

- (void)setViewLayout {
    
    //提示
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(-10));
        make.width.equalTo(@(kScreenWidth));
    }];
    
    //图标
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.titleLbl.mas_top).offset(-20);
        make.centerX.equalTo(@0);
    }];
    //重新加载
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(20);
        make.width.equalTo(@(kWidth(120)));
        make.height.equalTo(@(40));
    }];
}

#pragma mark - Setting
- (void)setTitle:(NSString *)title btnTitle:(NSString *)btnTitle icon:(NSString *)icon {
    
    self.titleLbl.text = title;
    [self.reloadBtn setTitle:btnTitle forState:UIControlStateNormal];
    self.iconIV.image = kImage(icon);
    //对视图布局
    [self setViewLayout];
}

#pragma mark - Events
- (void)reloadData {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeholderOperation)]) {
        
        [self.delegate placeholderOperation];
    }
}

@end
