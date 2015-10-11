//
//  TimelineRetrievalViewController.m
//  VestedFinanceExercise
//
//  Created by Chanikya on 10/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import "TimelineRetrievalViewController.h"
#import "ViewController.h"

@interface TimelineRetrievalViewController ()

@end

@implementation TimelineRetrievalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"timelineSegue"])
    {
        ViewController *vc = [segue destinationViewController];
        [vc setUsername:_usernameTextField.text];
    }
}

@end
