//
//  MyCommentTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CommentModel.h"

@interface MyCommentTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <CommentModel *>*comments;

@end
