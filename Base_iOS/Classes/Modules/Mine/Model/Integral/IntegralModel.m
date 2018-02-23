//
//  IntegralModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralModel.h"
#import "NSString+Extension.h"

@implementation IntegralModel
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.pic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj convertImageUrl]];
            
        }];
        
        _pics = newImgs;
    }
    
    return _pics;
}

@end
