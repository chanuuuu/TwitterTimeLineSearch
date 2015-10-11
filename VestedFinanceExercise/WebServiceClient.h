//
//  WebServiceClient.h
//  VestedFinanceExercise
//
//  Created by Chanikya on 10/10/2015.
//  Copyright © 2015 Chanikya Mandapathi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@protocol WebServiceClientDelegate;

@interface WebServiceClient : AFHTTPSessionManager

@property (nonatomic, weak) id<WebServiceClientDelegate>delegate;

+ (WebServiceClient *)sharedWebServiceClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

- (void) retrieveImage: (NSString *) param;

@end

@protocol WebServiceClientDelegate <NSObject>

@optional
-(void)webServiceClient:(WebServiceClient *)client didUpdateWithImage:(id)data;
-(void)webServiceClient:(WebServiceClient *)client didFailWithError:(NSError *)error;

@end