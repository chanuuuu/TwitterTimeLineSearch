//
//  ViewController.m
//  VestedFinanceExercise
//
//  Created by Chanikya on 9/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
#import "STTwitter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    //NSMutableArray *tweetsArray;
    //NSMutableArray *imagesArray;
    
    NSMutableArray *timelineArray;
    WebServiceClient *wClient;
    UIActivityIndicatorView *spinner;
}
@property (strong, nonatomic) NSArray *twitterData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    wClient = [WebServiceClient sharedWebServiceClient];
    wClient.delegate = self;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0, 0, 24, 24);
    
    //imagesArray = [[NSMutableArray alloc] init];
    timelineArray = [[NSMutableArray alloc] init];
    [self getTweets];
    
}


- (void) getTweets
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"XpOjuLxOtj2D4t2PLNSyDzz3X" consumerSecret:@"Qdxq5oUg4qeU27FonG1KtS4FYG6JAXbLp0Q6h7m2I7Ja70FLV3"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *userName)
     {
         [twitter getUserTimelineWithScreenName:_username count:10 successBlock:^(NSArray *statuses) {
             //tweetsArray = [NSMutableArray arrayWithArray:statuses];
             
             for(int i=0; i<statuses.count; i++)
             {
                 NSDictionary *tempDict1 = statuses[i];
                 NSMutableDictionary *tempDict2 = [[NSMutableDictionary alloc] init];
                 [tempDict2 setValue:tempDict1[@"text"] forKey:@"tweet"];
                 
                 NSDateFormatter *dateFormatter= [NSDateFormatter new];
                 dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                 [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
                 NSDate *date = [dateFormatter dateFromString:tempDict1[@"created_at"]];
                 [tempDict2 setValue:date forKey:@"createdAt"];
                 
                 [timelineArray addObject:tempDict2];
                 
             }
             
             [self getImages];
             [self.tableView reloadData];
             
         } errorBlock:^(NSError *error)
          {
              
          }];
         
     } errorBlock:^(NSError *error)
     {
         
     }];
}

- (void) getImages
{
    for(int i=0; i < timelineArray.count; i++)
    {
        NSDictionary *resDict = timelineArray[i];
        [wClient retrieveImage:resDict[@"tweet"]];
    }
}



- (void)webServiceClient:(WebServiceClient *)client didUpdateWithImage:(id) data ForText:(NSString *)text
{
    NSArray *tempArray = [[data valueForKey:@"responseData"] valueForKey:@"results"];
    if(tempArray.count>0)
    {
    NSDictionary *tempDict = tempArray[0];
    NSString *url = [tempDict valueForKey:@"url"];
    if(url)
    {
        //[imagesArray addObject: url];
        
        for(NSDictionary *tDict in timelineArray)
        {
            if([[tDict valueForKey:@"tweet"] isEqualToString:text])
            {
                [tDict setValue:url forKey:@"url"];
                NSLog(@"Dict value: %@", tDict);
            }
        }
        
        
    [self.tableView reloadData];
    //[spinner stopAnimating];
    //int row = [imagesArray indexOfObject:url];
    //NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }

    }
    
}


- (void)webServiceClient:(WebServiceClient *)client didFailWithError:(NSError *)error
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error Retrieving Data"
                                  message:@"There was a problem in connecting to the service.. Please check your internet connection"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  timelineArray.count;   //tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    CustomTableCell *cCell = (CustomTableCell *) cell;
    
    //cCell.accessoryView = spinner;
    [cCell addSubview:spinner];
    [spinner startAnimating];
    
//    NSInteger idx = indexPath.row;
//    NSDictionary *t = tweetsArray[idx];
    
    cCell.labelOutlet.text = [timelineArray[indexPath.row] valueForKey:@"tweet"];              //t[@"text"];
    
//    if(imagesArray.count == 0)
//    {
//       cCell.imageOutlet.image = [UIImage imageNamed:@"placeholder1.jpg"];
//    }
    
    if([timelineArray[indexPath.row] valueForKey:@"url"])                                      //(indexPath.row < [imagesArray count])
    {
        NSURL *url = [NSURL URLWithString:[timelineArray[indexPath.row] valueForKey:@"url"]]; //[NSURL URLWithString:imagesArray[indexPath.row]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cCell.imageOutlet.image = [[UIImage alloc] initWithData:data];
        [spinner stopAnimating];
       
    }
    
    else {
        cCell.imageOutlet.image = [UIImage imageNamed:@"placeholder1.jpg"];
    }
    
    return cell;
}


- (IBAction)sort:(id)sender {
    
    
    if([_sortOutlet.title isEqualToString:@"Sort(A-Z)"])
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tweet" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [timelineArray sortUsingDescriptors:sortDescriptors];
    }
    else {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
        [timelineArray sortUsingDescriptors:sortDescriptors];
    }
    
    _sortOutlet.title = [_sortOutlet.title isEqualToString:@"Sort(A-Z)"] ? @"Sort(Recent)" : @"Sort(A-Z)";
    
    [self.tableView reloadData];

}
@end
