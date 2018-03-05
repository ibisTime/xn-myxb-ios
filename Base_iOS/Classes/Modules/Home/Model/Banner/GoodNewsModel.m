//
//  GoodNewsModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "GoodNewsModel.h"
#import "NSString+Extension.h"

@implementation GoodNewsModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        return @"description";
    }
    
    return propertyName;
}

- (NSArray *)pics {
    
    if (!_pics) {
        
        NSArray *imgs = [self.advPic componentsSeparatedByString:@"||"];
        NSMutableArray *newImgs = [NSMutableArray arrayWithCapacity:imgs.count];
        [imgs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [newImgs addObject:[obj convertImageUrl]];
            
        }];
        
        _pics = newImgs;
    }
    
    return _pics;
}

@end
