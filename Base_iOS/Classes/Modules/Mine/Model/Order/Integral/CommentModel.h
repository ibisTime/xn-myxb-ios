//
//  CommentModel.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseModel.h"

@interface CommentModel : BaseModel

//原生数据
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status;
//评论时间
@property (nonatomic, copy) NSString *commentDatetime;
@property (nonatomic, copy) NSString *content;
//userId
@property (nonatomic, copy) NSString *commenter;

@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *entityCode;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger score;

//
@property (nonatomic, assign) CGFloat commentHeight;

@end
