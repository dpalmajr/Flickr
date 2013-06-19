//
//  DetailViewController.h
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet AsyncImageView *imgFullSizeImage;

@end
