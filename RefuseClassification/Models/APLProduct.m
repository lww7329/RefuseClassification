/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The data model object describing the product displayed in both main and results tables.
 */

#import "APLProduct.h"

@implementation APLProduct

+ (APLProduct *)productWithType:(NSString *)type name:(NSString *)name type2:(NSString *)type2 year:(NSNumber *)year price:(NSNumber *)price {
    APLProduct *newProduct = [[self alloc] init];
    newProduct.hardwareType = type;
    newProduct.title = name;
    newProduct.type=type2;
    newProduct.yearIntroduced = year;
    newProduct.introPrice = price;
    
    return newProduct;
}

+ (NSString *)deviceTypeTitle {
    return NSLocalizedString(@"Device", @"Device type title");
}
+ (NSString *)desktopTypeTitle {
    return NSLocalizedString(@"Desktop", @"Desktop type title");
}
+ (NSString *)portableTypeTitle {
    return NSLocalizedString(@"Portable", @"Portable type title");
}

+ (NSArray *)deviceTypeNames {
    static NSArray *deviceTypeNames = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        deviceTypeNames =
              @[[APLProduct deviceTypeTitle], [APLProduct portableTypeTitle], [APLProduct desktopTypeTitle]];
    });

    return deviceTypeNames;
}

+ (NSString *)displayNameForType:(NSString *)type {
    static NSMutableDictionary *deviceTypeDisplayNamesDictionary = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        deviceTypeDisplayNamesDictionary = [[NSMutableDictionary alloc] init];
        for (NSString *deviceType in self.deviceTypeNames) {
            NSString *displayName = NSLocalizedString(deviceType, @"dynamic");
            deviceTypeDisplayNamesDictionary[deviceType] = displayName;
        }
    });

    return deviceTypeDisplayNamesDictionary[type];
}


#pragma mark - Encoding/Decoding

NSString *const NameKey = @"NameKey";
NSString *const Type2Key = @"Type2Key";
NSString *const TypeKey = @"TypeKey";
NSString *const YearKey = @"YearKey";
NSString *const PriceKey = @"PriceKey";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        _title = [aDecoder decodeObjectForKey:NameKey];
        _type =[aDecoder decodeObjectForKey:Type2Key];
        _hardwareType = [aDecoder decodeObjectForKey:TypeKey];
        _yearIntroduced = [aDecoder decodeObjectForKey:YearKey];
        _introPrice = [aDecoder decodeObjectForKey:PriceKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:NameKey];
    [aCoder encodeObject:self.type forKey:Type2Key];
    [aCoder encodeObject:self.hardwareType forKey:TypeKey];
    [aCoder encodeObject:self.yearIntroduced forKey:YearKey];
    [aCoder encodeObject:self.introPrice forKey:PriceKey];
}

@end
