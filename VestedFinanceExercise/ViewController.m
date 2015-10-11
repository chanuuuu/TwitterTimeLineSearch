//
//  ViewController.m
//  VestedFinanceExercise
//
//  Created by Chanikya on 9/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableCell.h"
#import "Tweet.h"
#import "TweetsSet.h"
#import "STTwitter.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    //TweetsSet *tweetsArray;
    NSMutableArray *tweetsArray;
    NSMutableArray *imagesArray;
    WebServiceClient *wClient;
}
@property (strong, nonatomic) NSArray *twitterData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    wClient = [WebServiceClient sharedWebServiceClient];
    wClient.delegate = self;
    
    imagesArray = [[NSMutableArray alloc] init];
    [self getTweets];
    
}


- (void) getTweets
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"XpOjuLxOtj2D4t2PLNSyDzz3X" consumerSecret:@"Qdxq5oUg4qeU27FonG1KtS4FYG6JAXbLp0Q6h7m2I7Ja70FLV3"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *userName)
     {
         [twitter getUserTimelineWithScreenName:_username count:10 successBlock:^(NSArray *statuses) {
             tweetsArray = [NSMutableArray arrayWithArray:statuses];
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
    for(int i=0; i < tweetsArray.count; i++)
    {
        NSDictionary *resDict = tweetsArray[i];
        [wClient retrieveImage:resDict[@"text"]];
    }
}



- (void)webServiceClient:(WebServiceClient *)client didUpdateWithImage:(id) data
{
    NSArray *tempArray = [[data valueForKey:@"responseData"] valueForKey:@"results"];
    if(tempArray.count>0)
    {
    NSDictionary *tempDict = tempArray[0];
    NSString *url = [tempDict valueForKey:@"url"];
    if(url)
    {
    [imagesArray addObject: url];
    //[self.tableView reloadData];
    int row = [imagesArray indexOfObject:url];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
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
    
    return tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    CustomTableCell *cCell = (CustomTableCell *) cell;
    
    NSInteger idx = indexPath.row;
    NSDictionary *t = tweetsArray[idx];
    
    cCell.labelOutlet.text = t[@"text"];
    
    if(imagesArray.count == 0)
    {
       cCell.imageOutlet.image = [UIImage imageNamed:@"placeholder1.jpg"];
    }
    
    if(indexPath.row < [imagesArray count])
    {
        NSURL *url = [NSURL URLWithString:imagesArray[indexPath.row]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cCell.imageOutlet.image = [[UIImage alloc] initWithData:data];
       
    }
    
    return cell;
}





@end
