//
//  CountryCodesViewController.h
//  Country List
//
//  Created by Vladislav Kartashov on 20/01/15.
//  Copyright (c) 2015 Pradyumna Doddala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountrySelectionViewController : UITableViewController <UISearchDisplayDelegate>

- (instancetype)initWithCompletionBlock:(void(^)(NSDictionary *county))completionBlock;
@end
