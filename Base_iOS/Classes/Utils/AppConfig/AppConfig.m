//
//  AppConfig.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppConfig.h"

void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    self.companyCode = @"CD-CXB000020";
    self.systemCode = @"CD-CXB000020";
    
    switch (_runEnv) {
            
        case RunEnvRelease: {
            
            self.qiniuDomain = @"http://p8i9tvzga.bkt.clouddn.com";
            self.addr = @"http://47.52.77.214:4001";

        }break;
            
        case RunEnvDev: {
            
            self.qiniuDomain = @"http://otoieuivb.bkt.clouddn.com";
            self.addr = @"http://121.43.101.148:4401";
            
        }break;
            
        case RunEnvTest: {
            
            self.qiniuDomain = @"http://p8i9tvzga.bkt.clouddn.com";
            self.addr = @"http://47.96.161.183:4401";
//            self.addr = @"http://120.26.6.213:4401";

        }break;
            
    }
    
}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

- (NSString *)wxKey {
    
    return @"wxd0c1725a396dada6";
}

@end
