//
//  NSDictionary+CountryCode.m
//  Country List
//
//  Created by Vladislav Kartashov on 19/01/15.
//  Copyright (c) 2015 Pradyumna Doddala. All rights reserved.
//

#import "NSDictionary+CountryCode.h"
#define kCountryNameKey @"name"

@implementation NSDictionary (CountryCode)
- (NSString *)countryName {
    return [self objectForKey:kCountryNameKey];
}
@end
