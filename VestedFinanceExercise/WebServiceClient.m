//
//  WebServiceClient.m
//  VestedFinanceExercise
//
//  Created by Chanikya on 10/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import "WebServiceClient.h"

static NSString * const BaseURLString = @"https://ajax.googleapis.com/ajax/services/search/";

@implementation WebServiceClient

NSMutableArray *resultArray;


//provides access to singleton object of the class
+ (WebServiceClient *)sharedWebServiceClient
{
    static WebServiceClient *_sharedWebServiceClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWebServiceClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    });
    
    return _sharedWebServiceClient;
}

// Initializes the object with prolific web service base url
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        //self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

// Retrieves All books from Prolific WebService -- request to GET /books
- (void) retrieveImage:(NSString *) text {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"q"] = text;
    parameters[@"v"] = @"1.0";
    
    [self GET:@"images"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          //NSLog(@"JSON: %@", responseObject);
          
          if ([self.delegate respondsToSelector:@selector(webServiceClient:didUpdateWithImage: ForText:)]) {
              [self.delegate webServiceClient:self didUpdateWithImage:responseObject ForText:text];
              
          }
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          NSLog(@"error %@", error);
          if ([self.delegate respondsToSelector:@selector(webServiceClient:didFailWithError:)]) {
              [self.delegate webServiceClient:self didFailWithError:error];
          }
      }];
    
}


@end

