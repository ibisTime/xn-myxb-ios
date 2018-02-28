//
//  TripListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "TripListModel.h"

@interface TripListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <TripListModel *>*trips;

@end
