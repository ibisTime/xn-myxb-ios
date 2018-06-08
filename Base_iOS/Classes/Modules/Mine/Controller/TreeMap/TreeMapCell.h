//
//  TreeMapCell.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TreeMacModel.h"
@interface TreeMapCell : BaseTableViewCell

@property (nonatomic , strong)UIImageView *headerImageView;

@property (nonatomic , strong)UILabel *nameLable;

@property (nonatomic , strong)UIView *lineview;

@property (nonatomic , strong)TreeMacModel *model;

@end
