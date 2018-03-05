//
//  RankingListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "RankingModel.h"

#define kHeaderViewHeight kWidth(210)

@interface RankingListTableView : TLTableView
//排行榜
@property (nonatomic, strong) NSArray <RankingModel *>*rankingList;

@end
