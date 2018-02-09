//
//  QuestionModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import <UIKit/UIKit.h>

@class AnswerModel;

@interface QuestionModel : BaseModel

//问题
@property (nonatomic, copy) NSString *title;
//回答
@property (nonatomic, copy) NSString *content;
//折叠等级(0:一级, 1:二级)
@property (nonatomic, assign) NSInteger level;
//是否折叠
@property (nonatomic, assign) BOOL isFold;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
