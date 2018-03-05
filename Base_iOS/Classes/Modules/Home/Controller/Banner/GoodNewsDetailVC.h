//
//  GoodNewsDetailVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
//M
#import "GoodNewsModel.h"

@interface GoodNewsDetailVC : BaseViewController
//
@property (nonatomic, strong) GoodNewsModel *news;
//类型
@property (nonatomic, copy) NSString *type;

@end
