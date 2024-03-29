/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The data model object describing the product displayed in both main and results tables.
 */
#import <Foundation/Foundation.h>
@interface APLProduct : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *hardwareType;
@property (nonatomic, copy) NSNumber *yearIntroduced;
@property (nonatomic, copy) NSNumber *introPrice;

+ (APLProduct *)productWithType:(NSString *)type name:(NSString *)name type2:(NSString *)type2 year:(NSNumber *)year price:(NSNumber *)price;

+ (NSArray *)deviceTypeNames;
+ (NSString *)displayNameForType:(NSString *)type;

+ (NSString *)deviceTypeTitle;
+ (NSString *)desktopTypeTitle;
+ (NSString *)portableTypeTitle;

@end
