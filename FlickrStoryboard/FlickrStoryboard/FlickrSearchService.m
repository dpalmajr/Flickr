//
//  FlickrSearchService.m
//  FlickrStoryboard
//
//  Created by Donovan Palma on 2013-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

/*
 Here is what a sample json response looks like when coming back from the flickr api:
 {
     photos =     {
         page = 1;
         pages = 8865;
         perpage = 100;
         photo =  ({
             farm = 6;
             id = 9084416911;
             isfamily = 0;
             isfriend = 0;
             ispublic = 1;
             owner = "91314629@N03";
             secret = f4916a69b1;
             server = 5443;
             title = "West Euro Summer Meet";
         });
         total = 886497;
     };
     stat = ok;
 }

 */

#import "FlickrSearchService.h"
#import "FlickrResult.h"

@interface FlickrResponseMapper: NSObject

+(NSArray *)mapFlickrReponseToModels:(NSDictionary *)flickrResponse;

@end

@implementation FlickrResponseMapper


+(NSArray *)mapFlickrReponseToModels:(NSDictionary *)flickrResponse{
    if (!flickrResponse)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot transform nil argument" userInfo:nil];
    
    NSDictionary *photos = [flickrResponse objectForKey:@"photos"];
    NSArray *subPhotos = [photos objectForKey:@"photo"];
    
    NSMutableArray *collectionToReturn = [NSMutableArray new];
    
    for(NSDictionary *currentItem in subPhotos){
        NSString *identifier = [currentItem objectForKey:@"id"];
        NSString *owner = [currentItem objectForKey:@"owner"];
        NSString *secret = [currentItem objectForKey:@"secret"];
        NSInteger server = [[currentItem objectForKey:@"server"]intValue];
        NSString *title =[currentItem objectForKey:@"title"];
        NSInteger farm = [[currentItem objectForKey:@"farm"]intValue];
        
        FlickrResult *model = [[FlickrResult alloc] initWith:identifier photoOwner:owner photoScret:secret photoServer:server photoTitle:title photoFarm:farm];
        
        [collectionToReturn addObject:model];
    }
    
    return collectionToReturn;
}

@end


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

-(void)performSearchWithQuery:(NSString *)query onSuccess:(void(^)(NSArray *flickrPhotos))successCallback onFailure:(void(^)(NSError *error))errorCallback{
    
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
               
               NSLog(@"No data came back from the Flickr Api");
               
               successCallback([NSArray new]);
               return;
           }
           
           NSData *formattedJsonString = [self scrubJsonString:[NSString stringWithUTF8String:[responseData bytes]]];
           
           if (!formattedJsonString){
               NSLog(@"formatted json data is nil");
               successCallback([NSArray new]);
               return;
           }
           NSError *jsonParseError = nil;
           
           NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:formattedJsonString
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:&jsonParseError];
           if (jsonParseError){
               errorCallback(jsonParseError);
               return;
           }
           
           NSArray *transformedResults = [FlickrResponseMapper mapFlickrReponseToModels:jsonResult];
           
           successCallback(transformedResults);
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

-(NSData *) scrubJsonString:(NSString *)jsonString{
    
    NSString *jsonPrefix = [jsonString substringToIndex:14];

    if ([jsonPrefix isEqualToString:@"jsonFlickrApi("]){
        jsonString = [jsonString stringByReplacingOccurrencesOfString:jsonPrefix withString:@""];
    }
    
    NSInteger endOfString = [jsonString length]-1;
    NSString *endOfJsonString = [jsonString substringFromIndex:endOfString];
    
    if ([endOfJsonString isEqualToString:@")"]){
        NSRange range = NSMakeRange(endOfString,1);
        jsonString = [jsonString stringByReplacingCharactersInRange:range withString:@""];
    }
    
    NSLog(@"%@", jsonString);
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSURLRequest *)buildUrlRequestWithQueryWithQuery:(NSString *)query{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&format=json&safe_search=1&text=%@",kFlickrApiKey,query];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    return request;
    
}

@end
