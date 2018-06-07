//
//  WithdrawalTable.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "IntregalRecordModel.h"

@interface WithdrawalTable : TLTableView
@property (nonatomic , strong)NSMutableArray <IntregalRecordModel *>*modelArry;


@end
