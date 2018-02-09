//
//  ProposalTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/9.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "ProposalModel.h"

@interface ProposalTableView : TLTableView
//
@property (nonatomic, strong) NSArray <ProposalModel *>*proposals;

@end
