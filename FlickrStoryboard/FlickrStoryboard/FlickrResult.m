//
//  FlickrResult.m
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import "FlickrResult.h"

@implementation FlickrResult

@synthesize identifier, owner, secret, server, title, farm, thumbnailUrl, fullSizeUrl;

-(id)init{
    if(self = [super init]){
        
        return self;
    }
    
    return nil;
}

-(FlickrResult *)initWith:(NSString *)identifier_ photoOwner:(NSString *)owner_ photoScret:(NSString *)secret_ photoServer:(NSInteger)server_ photoTitle:(NSString *)title_ photoFarm:(NSInteger)farm_{

    if (self =[super init]){
        self.identifier = identifier_;
        self.owner = owner_;
        self.secret = secret_;
        self.server = server_;
        self.title = title_;
        self.farm = farm_;
        
        return self;
    }
    
    return nil;
}
/*
 Here is an exmample of the template url that must be used when retrieving a single image from the 
 flickr photo api
 
 http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
 
 The letter suffixes are as follows:
 
 s	small square 75x75
 q	large square 150x150
 t	thumbnail, 100 on longest side
 m	small, 240 on longest side
 n	small, 320 on longest side
 -	medium, 500 on longest side
 z	medium 640, 640 on longest side
 c	medium 800, 800 on longest side†
 b	large, 1024 on longest side*
 o	original image, either a jpg, gif or png, depending on source format
 
 */
-(NSString *)thumbnailUrl{
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%@_%@_t.jpg", self.farm, self.server,self.identifier, self.secret];
}


-(NSString *)fullSizeUrl{
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%@_%@_c.jpg", self.farm, self.server,self.identifier, self.secret];
}
@end
