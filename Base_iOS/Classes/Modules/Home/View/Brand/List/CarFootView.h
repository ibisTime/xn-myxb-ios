//
//  CarFootView.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

typedef void(^isCHooseAll)(BOOL);
typedef void(^ConfirmOrder)(void);


@interface CarFootView : BaseView
@property (nonatomic , copy)isCHooseAll ischoose;
@property (nonatomic , copy)NSString *priceA;
@property (nonatomic , copy)ConfirmOrder confirmorder;
@end
