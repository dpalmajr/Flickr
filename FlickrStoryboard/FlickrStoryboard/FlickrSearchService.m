//
//  FlickrSearchService.m
//  FlickrStoryboard
//
//  Created by Donovan Palma on 2013-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import "FlickrSearchService.h"

@implementation FlickrSearchService

NSString const * kFlickrApiKey = @"ec4e94aa6c298f4220d31f134df7dbad";

static NSOperationQueue *operationQueue;

+(FlickrSearchService *)instance{
    static FlickrSearchService *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[FlickrSearchService alloc]init];
        operationQueue = [[NSOperationQueue alloc]init];
    });
    
    return singleton;
    
}

-(void)performSearchWithQuery:(NSString *)query onSuccess:(void(^)(NSDictionary *resultData))successCallback onFailure:(void(^)(NSError *error))errorCallback{
    
    if (!successCallback || !errorCallback)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unable to issue network request with nil success callback or nil error callback" userInfo:nil];
        
    [NSURLConnection
       sendAsynchronousRequest:[self buildUrlRequestWithQueryWithQuery:query]
       queue:operationQueue
       completionHandler:^(NSURLResponse* response, NSData* responseData, NSError* responseError){
    
           if (responseError){
               errorCallback(responseError);
               return;
           }
           
           if (!responseData) {
               NSError *errorToReport = [[NSError alloc]initWithDomain:nil code:nil userInfo:nil];
               errorCallback(errorToReport);
               return;
           }
           
           NSError *jsonParseError = nil;
           
           NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonParseError];

           successCallback(jsonResult);
       }];

}

-(NSDictionary *)performSearchWithQuery:(NSString *)query{
    NSError *urlConnecitonError = nil;
    NSURLResponse *urlRepsonse = nil;
    NSURLRequest *urlRequest = [self buildUrlRequestWithQueryWithQuery:query];
    
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlRepsonse error:&urlConnecitonError];
    
    return nil;
}

#pragma mark - Private Methods

-(NSURLRequest *)buildUrlRequestWithQueryWithQuery:(NSString *)query{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&format=json&safe_search=1&text=%@",kFlickrApiKey,query];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    return request;
    
}

@end
