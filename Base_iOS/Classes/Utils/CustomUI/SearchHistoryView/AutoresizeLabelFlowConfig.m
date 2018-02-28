//
//  AutoresizeLabelFlowConfig.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AutoresizeLabelFlowConfig.h"

#import "AppColorMacro.h"

@implementation AutoresizeLabelFlowConfig

+ (AutoresizeLabelFlowConfig *)shareConfig {
    static AutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 2);
        self.lineSpace = 10;
        self.itemHeight = 25;
        self.itemSpace = 10;
        self.itemCornerRadius = self.itemHeight/2.0;
        self.itemColor = kLineColor;
        self.itemSelectBgColor = kAppCustomMainColor;
        self.textMargin = 20;
        self.textColor = kTextColor2;
        self.textSelectColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

@end
