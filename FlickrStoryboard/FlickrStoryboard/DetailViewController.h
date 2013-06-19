//
//  DetailViewController.h
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "DetailViewProtocol.h"

@interface DetailViewController : UIViewController<DetailViewProtocol>

@property (weak, nonatomic) IBOutlet AsyncImageView *imgFullSizeImage;

@end
