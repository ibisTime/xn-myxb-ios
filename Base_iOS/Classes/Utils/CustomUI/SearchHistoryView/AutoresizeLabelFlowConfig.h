//
//  AutoresizeLabelFlowConfig.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AutoresizeLabelFlowConfig : NSObject

@property (nonatomic) UIEdgeInsets  contentInsets;
@property (nonatomic) CGFloat       textMargin;
@property (nonatomic) CGFloat       lineSpace;
@property (nonatomic) CGFloat       itemHeight;
@property (nonatomic) CGFloat       itemSpace;
@property (nonatomic) CGFloat       itemCornerRadius;
//标签颜色
@property (nonatomic) UIColor       *itemColor;
//标签选中颜色
@property (nonatomic) UIColor       *itemSelectBgColor;
@property (nonatomic) UIColor       *textColor;
@property (nonatomic) UIColor       *textSelectColor;
@property (nonatomic) UIFont        *textFont;
@property (nonatomic) UIColor       *backgroundColor;

+ (AutoresizeLabelFlowConfig *)  shareConfig;

@end
