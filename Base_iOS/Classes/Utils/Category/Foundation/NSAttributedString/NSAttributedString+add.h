//
//  NSAttributedString+add.h
//  ZHCustomer
//
//  Created by  蔡卓越 on 2016/12/26.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (add)

+ (NSAttributedString *)convertImg:(UIImage *)img bounds:(CGRect)bounds;

+ (NSAttributedString *)getAttributedStringWithImgStr:(NSString *)imgStr bounds:(CGRect)bounds string:(NSString *)string;

+ (NSAttributedString *)getAttributedStringWithImgStr:(NSString *)imgStr index:(NSInteger)index string:(NSString *)string labelHeight:(CGFloat)height;

- (NSAttributedString *)getAttachmentTextWithStr:(NSString *)labelText image:(id)data;
@end
