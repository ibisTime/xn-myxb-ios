//
//  NSAttributedString+add.m
//  ZHCustomer
//
//  Created by  蔡卓越 on 2016/12/26.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "NSAttributedString+add.h"
#import <YYText.h>

@implementation NSAttributedString (add)

+ (NSAttributedString *)convertImg:(UIImage *)img bounds:(CGRect)bounds {

    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = img;
    textAttachment.bounds = bounds;
    return [NSAttributedString attributedStringWithAttachment:textAttachment];

}

+ (NSAttributedString *)getAttributedStringWithImgStr:(NSString *)imgStr bounds:(CGRect)bounds string:(NSString *)string {
    
    NSAttributedString *attrStr = [NSAttributedString convertImg:[UIImage imageNamed:imgStr] bounds:bounds];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attr insertAttributedString:attrStr atIndex:string.length];
    
    return attr;
}

+ (NSAttributedString *)getAttributedStringWithImgStr:(NSString *)imgStr index:(NSInteger)index string:(NSString *)string labelHeight:(CGFloat)height {
    
    UIImage *image = [UIImage imageNamed:imgStr];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat fixelW = CGImageGetWidth(image.CGImage)/(scale*1.0);
    CGFloat fixelH = CGImageGetHeight(image.CGImage)/(scale*1.0);
    
    CGFloat topM = (fixelH - height)/2.0;
    
    NSAttributedString *attrStr = [NSAttributedString convertImg:[UIImage imageNamed:imgStr] bounds:CGRectMake(0, topM, fixelW, fixelH)];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attr insertAttributedString:attrStr atIndex:index];
    
    return attr;
}

@end
