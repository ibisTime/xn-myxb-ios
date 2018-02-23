//
//  BrandModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface BrandModel : BaseModel
//头像
@property (nonatomic, copy) NSString *photo;
//昵称
@property (nonatomic, copy) NSString *nickName;
//评分
@property (nonatomic, assign) NSInteger score;
//个人简介
@property (nonatomic, copy) NSString *introduce;
//评论内容
@property (nonatomic, copy) NSString *content;
//时间
@property (nonatomic, copy) NSString *time;
//
@property (nonatomic, assign) CGFloat commentHeight;
//
@property (nonatomic, assign) CGFloat contentHeight;

@end
