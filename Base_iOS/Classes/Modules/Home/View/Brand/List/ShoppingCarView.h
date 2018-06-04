//
//  ShoppingCarView.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTableView.h"
#import "ShopCarModel.h"

typedef void(^chooseGood)(NSMutableArray *);

@interface ShoppingCarView : TLTableView
@property (nonatomic, strong) NSArray <ShopCarModel *>*brands;
@property (nonatomic, copy)chooseGood chooseBlock;
- (void)chouseAll;
@end
