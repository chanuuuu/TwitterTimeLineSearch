//
//  ViewController.h
//  VestedFinanceExercise
//
//  Created by Chanikya on 9/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClient.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WebServiceClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *username;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortOutlet;
- (IBAction)sort:(id)sender;

@end

