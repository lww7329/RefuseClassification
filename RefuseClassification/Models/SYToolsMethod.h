//
//  SYToolsMethod.h
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SYToolsMethod : NSObject
+(UIImage*) createImageWithColor: (UIColor*) color;
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end

NS_ASSUME_NONNULL_END
