//
//  UIBarButtonItem+YeeBadge.m
//  BadgeViewDemo
//
//  Created by Yee on 2018/4/13.
//  Copyright © 2018年 Yee. All rights reserved.
//

#import "UIBarButtonItem+YeeBadge.h"
#include <objc/runtime.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIBarButtonItem (YeeBadge)

-(id)forwardingTargetForSelector:(SEL)aSelector{
    
    struct objc_method_description  description = protocol_getMethodDescription(@protocol(YeeBadgeProtocol), aSelector, NO, YES);
    if (description.name != NULL) {
        
        return [self  findBadgeTargetView];
    }
    return  [super forwardingTargetForSelector:aSelector];;
}
-(UIView*)findBadgeTargetView{
    
    UIView *_badgeView= [self valueForKey:@"_view"];
    return _badgeView;
}
@end
#pragma clang diagnostic pop
#pragma clang diagnostic pop
