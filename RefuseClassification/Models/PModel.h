//
//  PModel.h
//  FileDownloadPro
//
//  Created by wei.z on 2019/7/4.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PModel : NSObject
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * source;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * ptime;
@property(nonatomic,copy)NSString * link;
@property(nonatomic,copy)NSString * digest;
@end

NS_ASSUME_NONNULL_END
