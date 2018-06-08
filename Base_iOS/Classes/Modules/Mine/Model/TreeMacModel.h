//
//  TreeMacModel.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface TreeMacModel : BaseModel

@property (nonatomic , assign) NSInteger parentId;//父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , assign) NSInteger nodeId;//本节点的id

@property (nonatomic , strong) NSString *name;//本节点的名称

@property (nonatomic , assign) NSInteger depth;//该节点的深度

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic , assign) BOOL ShowLinview;

@property (nonatomic , strong) NSString *isRelation;//关系数

@property (nonatomic , strong)NSArray *lineList;//1级服务商数组

@property (nonatomic , strong)NSArray *jxsList;//经销商数组

@property (nonatomic , strong)NSArray *fwsList;//服务商数组

@property (nonatomic , strong)NSArray *mgJxsList;//2级服务商数组

@property (nonatomic , strong) NSString *kind;//

@property (nonatomic , assign)NSNumber *maxNumber;

@property (nonatomic , strong) NSString *mdUserId;//

@property (nonatomic , strong) NSString *mobile;//

@property (nonatomic , strong) NSString *nickname;//

@property (nonatomic , strong) NSString *parentAUserId;//

@property (nonatomic , assign)NSNumber *parentAline;

@property (nonatomic , strong) NSString *parentBUserId;//

@property (nonatomic , assign)NSNumber *parentBline;

@property (nonatomic , assign)NSNumber *parentOrderNo;

@property (nonatomic , strong) NSString *realName;//

@property (nonatomic , assign)NSNumber *tradepwdFlag;

@property (nonatomic , strong) NSString *userId;//

@property (nonatomic , strong) NSString *photo;//

@end
