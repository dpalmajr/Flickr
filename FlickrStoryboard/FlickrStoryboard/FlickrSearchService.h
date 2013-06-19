//
//  FlickrSearchService.h
//  FlickrStoryboard
//
//  Created by Donovan Palma on 2013-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrSearchService : NSObject

+(FlickrSearchService *)instance;

-(void)performSearchWithQuery:(NSString *)query onSuccess:(void(^)(NSArray *flickrPhotos))successCallback onFailure:(void(^)(NSError *error))errorCallback;


-(NSDictionary *)performSearchWithQuery:(NSString *)query;

@end
