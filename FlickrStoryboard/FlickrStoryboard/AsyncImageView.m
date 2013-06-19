//
//  AsyncImageView.m
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import "AsyncImageView.h"


@implementation AsyncImageView{
    NSString *_imageUrl;
    UIActivityIndicatorView *_activityIndicatorView;
}
static NSOperationQueue *operationQueue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc]init];
    });

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(NSString *)imageUrl{
    return _imageUrl;
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = [imageUrl copy];
    
    //add the activity view as a subview
    if (!_activityIndicatorView){
        
        _activityIndicatorView  = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_activityIndicatorView setCenter:CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2)];
        
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    //make sure you are not adding the same subview twice
    [_activityIndicatorView removeFromSuperview];
    
    [self addSubview:_activityIndicatorView];
    
    [_activityIndicatorView startAnimating];
    
    //issue a network request
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_imageUrl]];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *responseError){
        
        if (responseError){
            NSLog(@"An error occured while trying to retrieve image. Error: %@", [responseError description]);
            return;
        }
        
        //be sure to update the view on the main thread
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:responseData waitUntilDone:NO];
    }];
}

-(void)updateImage:(NSData *)imageData{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    
    UIImage *udpatedImage = [UIImage imageWithData:imageData];
    self.image = udpatedImage;
    
}
@end
