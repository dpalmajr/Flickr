//
//  SearchViewController.m
//  FlickrStoryboard
//
//  Created by Donovan Palma Jr on 13-06-19.
//  Copyright (c) 2013 Donovan Palma Jr. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrSearchService.h"
#import "DetailViewProtocol.h"
#import "FlickrResult.h"
#import "SearchResultTableViewCell.h"

@interface SearchViewController ()

@property(nonatomic, strong) NSArray *dataItems;
@property(nonatomic) NSInteger selectedIndex;

@end

@implementation SearchViewController

#pragma mark - UIViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    id<DetailViewProtocol> destinationViewController = (id<DetailViewProtocol>)[segue destinationViewController];
    FlickrResult *model = [self.dataItems objectAtIndex:self.selectedIndex];
    
    destinationViewController.imageURL = model.fullSizeUrl;
}

#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   SearchResultTableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:@"flickrResultCell"];
    cell.imgThumbnail.image = nil;
    FlickrResult *model = [self.dataItems objectAtIndex:indexPath.row];
    cell.lblTitle.text = model.title;
    cell.imgThumbnail.imageUrl = model.thumbnailUrl;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.dataItems)
        return 0;
    
    return self.dataItems.count;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    self.selectedIndex = indexPath.row;
    
    //make sure selections to not persist
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchButtonPressed:nil];
    return;
}

- (IBAction)searchButtonPressed:(id)sender {
    NSString *searchText = self.txtSearchField.text;
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self.view endEditing:YES];
    
    [[FlickrSearchService instance]performSearchWithQuery:searchText
                                                onSuccess:^(NSArray *resultData){
                                                    
                                                    self.dataItems = resultData;
                                                    
                                                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
                                                }
                                                onFailure:^(NSError *error){
                                                    [self performSelectorOnMainThread:@selector(displayErrorMessage) withObject:nil waitUntilDone:NO];
                                                    NSLog(@"%@", [error description]);
                                                }];
}

#pragma  mark - Private Methods

-(void) reloadTableView{
    [self.tableView reloadData];
}

-(void)displayErrorMessage{

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Something went wrong while trying to get search results :(" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
}
@end
