//
//  CountryCodePickerViewController.h
//  Country List
//
//  Created by Vladislav Kartashov on 20/01/15.
//  Copyright (c) 2015 Pradyumna Doddala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCodePickerViewController : UINavigationController
- initWithCompletionBlock:(void(^)(NSDictionary *country))completion;
@end
