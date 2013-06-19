//
//  SearchViewController.h
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)searchButtonPressed:(id)sender;

@end
