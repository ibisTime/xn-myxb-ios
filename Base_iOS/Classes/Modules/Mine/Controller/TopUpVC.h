//
//  TopUpVC.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
@interface TopUpVC : BaseViewController
@property(nonatomic , copy)NSString *kind;
@property (nonatomic , strong)NSString *code;
@property (nonatomic , copy)NSString *deductAmount;
//我要成为 。。。。。
@property (nonatomic , assign)BOOL becomeWho;
//是否专家提成支付
@property (nonatomic , assign)BOOL isPayExperts;
@end
