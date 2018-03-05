//
//  GoodNewsTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "GoodNewsModel.h"

@interface GoodNewsTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <GoodNewsModel *>*newsList;
//
@property (nonatomic, assign) BOOL isDetail;

@end
