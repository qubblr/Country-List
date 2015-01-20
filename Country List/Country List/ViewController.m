//
//  ViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "ViewController.h"
#import "CountryCodePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    CountryCodePickerViewController *cs = [[CountryCodePickerViewController alloc] initWithCompletionBlock:^(NSDictionary *county) {
        if (county) {
            NSLog(@"%@", county);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:cs animated:YES completion:nil];
}

@end
