//
//  BrandDetailTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "BrandModel.h"
#import "CommentModel.h"

@interface BrandDetailTableView : TLTableView
//
@property (nonatomic, strong) BrandModel *detailModel;
//
@property (nonatomic, strong) NSMutableArray <CommentModel *>*commentList;
//code
@property (nonatomic, copy) NSString *code;

@end
