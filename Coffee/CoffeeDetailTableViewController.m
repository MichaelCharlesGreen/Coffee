//
//  CoffeeDetailTableViewController.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Display two cells in a table view
//  Top cell displays name
//  Bottom cell displays description, image, and lastUpdatedAt

#import "CoffeeDetailTableViewController.h"
#import "CoffeeDetailTopTableViewCell.h"
#import "CoffeeDetailBottomTableViewCell.h"
#import "CoffeeDetailModel.h"
#import "SocialSharingViewController.h"
#import "NSString+LabelStrings.h"
#import "UIButton+Title.h"
#import "Design.h"
#import "HTTPManager.h"
#import "UIImage+Scale.h"

enum {TopCell, BottomCell};

@interface CoffeeDetailTableViewController ()
@property (strong, nonatomic) NSMutableDictionary *offscreenCells; // dictionary of cells for determining heights
@property (strong, nonatomic) NSArray *coffee; // of a single CoffeeDetailModel
@property (strong, nonatomic) UITableView *tableView; // tableView for this View Controller.
@end

@implementation CoffeeDetailTableViewController

#pragma mark - Accessor
- (NSMutableDictionary *)offscreenCells
{
    if (!_offscreenCells) _offscreenCells = [NSMutableDictionary dictionary];
    
    return _offscreenCells;
}

// Reload the table view when the Model is set or changes.
- (void)setCoffee:(NSArray *)coffee
{
    _coffee = coffee;
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Configure the tableView
    
    // Set the color of the cell separator line.
    [_tableView setSeparatorColor:[Design darkGrayColor]];
    
    // Do not display trailing empty cells
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Register cells for reuse.
    [_tableView registerClass:[CoffeeDetailTopTableViewCell class] forCellReuseIdentifier:TopDetailCellIdentifier];
    [_tableView registerClass:[CoffeeDetailBottomTableViewCell class] forCellReuseIdentifier:BottomDetailCellIdentifier];
    
    // Supply estimated row height for configuring the tableView.
    _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    // Do not allow user to select a row.
    _tableView.allowsSelection = NO;
    
    return _tableView;
}

#pragma mark - move me Action
- (void)onShare:(id)sender
{
    [self displaySocialSharingViewController];
}

#pragma mark - UIViewController
- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavbar];
    
    // Set Model
   [self callServiceForData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Add observer for change in Dynamic Type size from Settings.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove Dynamic Type size-change observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

#pragma mark - Notification
// Selector designated in Dynamic Type size-change notification.
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
// Optional; implemented to show intent.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Top cell is the name; bottom cell is the description, image, and lastUpdatedAt label.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Return either of the two cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    enum {TopCell, BottomCell};
    
    // Model for both cells.
    CoffeeDetailModel *model = self.coffee.firstObject;
    
    if (indexPath.row == TopCell) {
        // For top cell
        // Dequeue cell
        CoffeeDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopDetailCellIdentifier];
        
        // Configure the cell...
        [cell updateFonts]; // Using Dynamic Type configured in cell class.
        
        cell.itemNameLabel.text = model.name;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    } else if (indexPath.row == BottomCell) {
        // For bottom cell
        // Dequeue cell
        CoffeeDetailBottomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BottomDetailCellIdentifier];
        
        // Configure the cell...
        [cell updateFonts]; // Using Dynamic Type configured in cell class.
        
        cell.itemDescriptionLabel.text = model.detailDescription;
        cell.lastUpdatedAtLabel.text = [model.lastUpdatedAt toLastUpdatedAtString];
  
        if ([model.imageURLString length] > 0) {
            // There may be a cached image.
            if (model.image) {
                cell.itemImageView.image = model.image;
                [cell.itemImageView invalidateIntrinsicContentSize];
            } else {
                [self asyncImageLoad:model.imageURLString forIndexPath:indexPath];
            }
        }
        
        // Do not display cell separator line.
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, cell.bounds.size.width);
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Helper
// Display controller for sharing on social media. Rise from bottom of screen.
- (void)displaySocialSharingViewController
{
    SocialSharingViewController *socialSharingViewController = [[SocialSharingViewController alloc] init];
    socialSharingViewController.modelToShare = [self.coffee firstObject];
    [self presentViewController:socialSharingViewController
                       animated:YES
                     completion:nil];
}

// Configure the navbar
- (void)configureNavbar
{
    // Add navbar button, SHARE, to share coffee detail on social media.
    UIButton *shareButton = [UIButton buttonWithTitle:@"SHARE"];
    [shareButton addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Remove Back title from nav bar button.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // Set color of Back chevron
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

// Set the model for this view by calling the service.
- (void)callServiceForData
{
    // Request Model data from service.
    HTTPManager *httpManager = [HTTPManager sharedHTTPManager];
    [httpManager getCoffeeForID:self.coffeeID
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            
                            // Create an array of an object built from JSON
                            NSError *error = nil;
                            CoffeeDetailModel *model;
                            model = [MTLJSONAdapter modelOfClass:[CoffeeDetailModel class]
                                              fromJSONDictionary:responseObject
                                                           error:&error];
                            // Set the Model.
                            self.coffee = @[model];
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            // handle error
                            NSLog(@"error: %@", error);
                        }];
}

// Download image for cell.
- (void)asyncImageLoad:(NSString *)urlString forIndexPath:(NSIndexPath *)indexPath
{
    if ([urlString length] > 0) {
        [[HTTPManager sharedHTTPManager] getImageAtURLString:urlString
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         
                                                         UIImage *image = nil;
                                                         if ([responseObject isKindOfClass:[UIImage class]]) {
                                                             image = [responseObject scaleToDisplaySize:DetailImageSize];
                                                         }
                                                         // create the image
                                                         //                                                     UIImage *image = [UIImage imageWithData:data];
                                                         
                                                         // cache the image
                                                         //            NSDictionary *post = [posts objectAtIndex:indexPath.row];
                                                         //            [post setObject:image forKey:@"picture_image"];
                                                         
                                                         // Model for both cells.
                                                         CoffeeDetailModel *model = self.coffee.firstObject;
                                                         model.image = image;
                                                         
                                                         // If visible, update the cell at indexPath
                                                         NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
                                                         if ([visiblePaths containsObject:indexPath]) {
                                                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                         }
                                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                         // handle error
                                                         NSLog(@"error: %@", error);
                                                     }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoffeeDetailModel *model = self.coffee.firstObject;
    
    CGFloat height = 0.0;
    
    if (indexPath.row == TopCell) {
        
        CoffeeDetailTopTableViewCell *cell = [self.offscreenCells objectForKey:TopDetailCellIdentifier];
        
        if (!cell) {
            cell = [[CoffeeDetailTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopDetailCellIdentifier];
            [self.offscreenCells setObject:cell forKey:TopDetailCellIdentifier];
        }
        
        // Configure cell
        [cell updateFonts];
        cell.itemNameLabel.text = model.name;
        
        // setNeedsUpdateConstraints makes sure a future call to updateConstraintsIfNeeded call updateConstraints.
        // setNeedsLayout makes sure a future call to layoutIfNeeded calls layoutSubviews.
        // When layoutSubviews is called, it also calls updateConstraintsIfNeeded.
        [cell setNeedsUpdateConstraints];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        
    } else if (indexPath.row == BottomCell) {
        
        CoffeeDetailBottomTableViewCell *cell = [self.offscreenCells objectForKey:BottomDetailCellIdentifier];
        
        if (!cell) {
            cell = [[CoffeeDetailBottomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BottomDetailCellIdentifier];
            [self.offscreenCells setObject:cell forKey:BottomDetailCellIdentifier];
        }
        
        // Configure cell
        [cell updateFonts];
        cell.itemDescriptionLabel.text = model.description;
        
        cell.itemImageView.image = model.image;
        [cell.itemImageView invalidateIntrinsicContentSize];
        
        cell.lastUpdatedAtLabel.text = model.lastUpdatedAt;
        
        // setNeedsUpdateConstraints makes sure a future call to updateConstraintsIfNeeded calls updateConstraints.
        // setNeedsLayout makes sure a future call to layoutIfNeeded calls layoutSubviews.
        // When layoutSubviews is called, it also calls updateConstraintsIfNeeded.
        [cell setNeedsUpdateConstraints];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
    }
    
    return height;
}

@end
