//
//  MyInfomationModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyInfomationModel.h"

@implementation MyInfomationModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

@end
