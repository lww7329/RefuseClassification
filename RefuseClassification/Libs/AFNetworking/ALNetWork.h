//
//  ALNetWork.h
//  ALPHA
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef void (^WTRequestFinishedBlock)(NSDictionary *dic);
typedef void (^WTRequestFailedBlock)(NSError *error);

@interface ALNetWork : NSObject
+ (instancetype)share;
//-(NSURLRequest*)getWithURL:(NSString*)url
//                        parameters:(NSDictionary*)parameters
//                          finished:(WTRequestFinishedBlock)finished
//                            failed:(WTRequestFailedBlock)failed;

//-(NSURLRequest*)postWithURL:(NSString*)url
//                 parameters:(NSDictionary*)parameters
//                   finished:(WTRequestFinishedBlock)finished
//                     failed:(WTRequestFailedBlock)failed;

-(void)getWithURL:(NSString*)url
                parameters:(NSDictionary*)parameters
                  finished:(WTRequestFinishedBlock)finished
                    failed:(WTRequestFailedBlock)failed;

-(void)postWithURL:(NSString*)url
                 parameters:(NSDictionary*)parameters
                   finished:(WTRequestFinishedBlock)finished
                     failed:(WTRequestFailedBlock)failed;
-(void)postWithUrlAndUpLoad:(NSString *)URLString
                 parameters:(id)parameters andDATA:(NSData *)imgData progress:(void (^)(NSProgress * ))uploadProgress finished:(WTRequestFinishedBlock)finished failed:(WTRequestFailedBlock)failed;
@property (nonatomic,assign) BOOL isLogin;
@end
