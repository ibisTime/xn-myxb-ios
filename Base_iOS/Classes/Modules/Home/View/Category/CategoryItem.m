//
//  CategoryItem.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CategoryItem.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface CategoryItem()

@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation CategoryItem

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
    
    self.backgroundColor = kWhiteColor;
    //
    self.iconIV = [[UIImageView alloc] init];
    
    [self addSubview:self.iconIV];
    //
    self.titleLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentCenter
                                 backgroundColor:kClearColor
                                            font:Font(14.0)
                                       textColor:kTextColor3];
    
    [self addSubview:self.titleLbl];
    
}

- (void)setSubViewLayout {
    
    //
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@(-20));
        make.centerX.equalTo(@0);
    }];
    
    CGFloat imgW = self.iconIV.image.size.width*0.9;
    
    //
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.titleLbl.mas_top).offset(-13);
        make.width.height.equalTo(@(imgW));
    }];
    
}

#pragma mark - Setting
- (void)setIcon:(NSString *)icon {
    
    _icon = icon;
    self.iconIV.image = kImage(icon);
    
    //布局
    [self setSubViewLayout];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLbl.text = title;
}

@end
