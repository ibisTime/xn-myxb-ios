//
//  MyCommentListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCommentListVC : BaseViewController
//评论对象
@property (nonatomic, copy) NSString *type;

@property (nonatomic , assign)BOOL isMySelf;

@end
