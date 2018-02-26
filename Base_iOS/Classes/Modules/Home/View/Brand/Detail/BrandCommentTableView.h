//
//  BrandCommentTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CommentModel.h"

@interface BrandCommentTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <CommentModel *>*commentList;

@end
