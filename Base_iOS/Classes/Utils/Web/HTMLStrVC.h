//
//  HTMLStrVC.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, HTMLType) {
    HTMLTypeAboutUs = 0,    //关于我们
    HTMLTypeRegProtocol,    //注册协议
    HTMLTypeIntregalRule,   //积分规则
    HTMLTypeHelpCenter,     //我的里面的帮助中心
    HTMLTypeFAQ,            //常见问题 （菜单内容）
};

@interface HTMLStrVC : BaseViewController

@property (nonatomic, assign) HTMLType type;

//@property (nonatomic, copy) NSString *ckey;

@end
