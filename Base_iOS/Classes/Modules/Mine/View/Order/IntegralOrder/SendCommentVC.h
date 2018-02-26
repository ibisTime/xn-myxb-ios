//
//  SendCommentVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentModel.h"

@interface SendCommentVC : BaseViewController

//产品code
@property (nonatomic, copy) NSString *code;
//
@property (nonatomic, copy) void(^commentSuccess)(void);

@end
