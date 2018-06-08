//
//  TreeTableView.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TLTableView.h"
@class TreeMacModel;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (TreeMacModel *)node;

@end

@interface TreeTableView : TLTableView

@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;

@end
