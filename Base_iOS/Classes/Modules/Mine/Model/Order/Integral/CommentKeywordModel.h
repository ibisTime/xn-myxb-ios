//
//  CommentKeywordModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

@interface CommentKeywordModel : BaseView
//code
@property (nonatomic, copy) NSString *code;
//关键字
@property (nonatomic, copy) NSString *word;
//用户类型
@property (nonatomic, copy) NSString *kind;
//评论数
@property (nonatomic, assign) NSInteger count;

@end
