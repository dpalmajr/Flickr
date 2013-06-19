//
//  FlickrResult.h
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrResult : NSObject

@property (nonatomic) NSString * identifier;
@property (nonatomic) NSString * owner;
@property (nonatomic) NSString * secret;
@property (nonatomic) NSInteger  server;
@property (nonatomic) NSInteger  farm;
@property (nonatomic) NSString * title;
@property (nonatomic, readonly) NSString * thumbnailUrl;
@property (nonatomic, readonly) NSString * fullSizeUrl;

-(FlickrResult *)initWith:(NSString *)identifier_ photoOwner:(NSString *)owner_ photoScret:(NSString *)secret_ photoServer:(NSInteger)server_ photoTitle:(NSString *)title_ photoFarm:(NSInteger)farm_;
@end
