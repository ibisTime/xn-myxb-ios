//
//  BrandCommentVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, OrderCommentType) {
    
    OrderCommentTypePerson = 0, //人
    OrderCommentTypeGood,       //物
};

@interface BrandCommentVC : BaseViewController
//产品code
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) void(^commentSuccess)(void);
//
@property (nonatomic, assign) OrderCommentType type;
//
@property (nonatomic, copy) NSString *commentKind;
//提示说明
@property (nonatomic, copy) NSString *placeholder;

@end
