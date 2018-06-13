//
//  TripListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "TripListModel.h"

@interface TripListCell : BaseTableViewCell
//
@property (nonatomic, strong) TripListModel *trip;

@property (nonatomic , assign)BOOL isTeam;

@end
