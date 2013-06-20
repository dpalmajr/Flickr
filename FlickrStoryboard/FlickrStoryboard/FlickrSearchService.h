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

/*
 Performs an asynchronous flickr photo search with the search criteria provided.
 */

-(void)performSearchWithQuery:(NSString *)query onSuccess:(void(^)(NSArray *flickrPhotos))successCallback onFailure:(void(^)(NSError *error))errorCallback;


/*
 Performs a synchronous flickr photos search with the search criteria provides
 */

-(NSDictionary *)performSearchWithQuery:(NSString *)query;

@end
