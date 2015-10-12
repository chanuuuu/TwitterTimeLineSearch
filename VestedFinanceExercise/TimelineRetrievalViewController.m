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
    
    _showTimelineOutlet.layer.cornerRadius = 5;
    _showTimelineOutlet.layer.borderWidth = 1;
    _showTimelineOutlet.layer.borderColor = [UIColor blackColor].CGColor;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"timelineSegue"])
    {
        ViewController *vc = [segue destinationViewController];
        [vc setUsername:_usernameTextField.text];
    }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.usernameTextField resignFirstResponder];
    }
}

@end
