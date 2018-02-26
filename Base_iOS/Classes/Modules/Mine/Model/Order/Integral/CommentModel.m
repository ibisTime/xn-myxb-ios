//
//  CommentModel.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/7.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

//- (instancetype)initWithCommentUserId:(NSString *)commentUserId commentUserNickname:(NSString *)commentUserNickname commentContent:(NSString *)commentContent parentCommentUserId:(NSString *)parentCommentUserId parentCommentUserNickname:(NSString *)parentCommentUserNickname commentDatetime:(NSString *)commentDatetime {
//
//    if (self= [super init]) {
//
//        self.commer = commentUserId;
//        self.nickname = commentUserNickname;
//        self.content = commentContent;
//
//        self.parentCommentUserId = commentUserId;
//        self.parentComment = [NSMutableDictionary dictionary];
//        self.parentComment[@"nickname"] = parentCommentUserNickname;
//        self.commDatetime = commentDatetime;
//        self.photo = [TLUser user].photo;
//
//    }
//
//    return self;
//
//}
//- (NSString *)commentUserId {
//
//    return self.commer;
//}
//
//- (NSString *)commentUserNickname {
//
//    if (self.nickname) {
//
//        return self.nickname;
//
//    } else {
//
//        return @"未知用户";
//
//
//    }
//
//}
//
//- (NSString *)parentCommentUserNickname {
//
//    if (self.parentComment && self.parentComment[@"nickname"]) {
//        return self.parentComment[@"nickname"];
//    }
//
//    return nil;
//
//}
//
//
//- (NSString *)parentCommentUserId {
//
//    if (self.parentComment && self.parentComment[@"commer"]) {
//        return self.parentComment[@"commer"];
//    }
//
//    return nil;
//
//}
//
//- (NSString *)commentContent{
//
//    return self.content;
//}
//
//- (NSString *)commentDatetime {
//
//    return self.commDatetime;
//}


@end
