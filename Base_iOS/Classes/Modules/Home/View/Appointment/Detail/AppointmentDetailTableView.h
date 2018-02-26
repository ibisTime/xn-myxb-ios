//
//  AppointmentDetailTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "AppointmentListModel.h"
#import "CommentModel.h"
#import "TripInfoModel.h"

@interface AppointmentDetailTableView : TLTableView
//
@property (nonatomic, strong) AppointmentListModel *detailModel;
//
@property (nonatomic, strong) NSMutableArray <CommentModel *>*commentList;
//行程列表
@property (nonatomic, strong) NSArray <TripInfoModel *>*trips;

@end
