//
//  SearchVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SearchType){
    
    SearchTypeGood = 0,   //物品
    SearchTypePerson,     //人
};

@interface SearchVC : BaseViewController
//搜索内容
@property (nonatomic, copy) NSString *searchText;
//搜索类型
@property (nonatomic, assign) SearchType searchType;
//具体类型
@property (nonatomic, copy) NSString *type;

@end
