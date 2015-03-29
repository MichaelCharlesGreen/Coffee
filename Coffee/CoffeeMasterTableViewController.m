//
//  CoffeeMasterTableViewController.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeMasterTableViewController.h"
#import "CoffeeMasterModel.h"
#import "CoffeeMasterTableViewCell.h"
#import "HTTPManager.h"
#import "CoffeeDetailTableViewController.h"
#import "UIImage+Scale.h"

@interface CoffeeMasterTableViewController ()
// References to cells used to calculate actual cell heights.
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@property (strong, nonatomic) NSArray *coffees; // of CoffeeMasterModel
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation CoffeeMasterTableViewController

#pragma mark - Accessor
- (NSMutableDictionary *)offscreenCells
{
    if (!_offscreenCells) _offscreenCells = [NSMutableDictionary dictionary];
    
    return _offscreenCells;
}

// Reload the table view when the Model is set or changes.
- (void)setCoffees:(NSArray *)coffees
{
    _coffees = coffees;
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Register table view cells for reuse.
    [_tableView registerClass:[CoffeeMasterTableViewCell class] forCellReuseIdentifier:MasterCellIdentifier];
    
    // Estimate row height.
    _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    // Allow selection of row for going to detail view.
    _tableView.allowsSelection = YES;
    
    return _tableView;
}

#pragma mark - UIViewController
- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Model
    [self callServiceForData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Adding observer for change in size of Dynamic Type.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove observer for change in size of Dynamic Type.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

#pragma mark - Notification
// Notification callback for change in Dynamic Type user settings.
// Reload the tableView to reflect the change in type size.
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
// One section; optional implementation to indicate intent.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.coffees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoffeeMasterModel *model = self.coffees[indexPath.row];
    
    // Cell object for this table view.
    CoffeeMasterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MasterCellIdentifier forIndexPath:indexPath];
    
    [cell updateFonts];
    cell.itemNameLabel.text = model.name;
    cell.itemDescriptionLabel.text = model.shortDescription;
    
    if ([model.imageURLString length] > 0) {
        // There may be a cached image.
        if (model.image) {
            cell.itemImageView.image = model.image;
            [cell.itemImageView invalidateIntrinsicContentSize];
        } else {
            [self asyncImageLoad:model.imageURLString forIndexPath:indexPath];
        }
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove highlight from selected cell.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get model for this Coffee
    CoffeeMasterModel *model = self.coffees[indexPath.row];
    
    CoffeeDetailTableViewController *coffeeDetailTableViewContoller = [[CoffeeDetailTableViewController alloc] init];
    coffeeDetailTableViewContoller.coffeeID = model.identifier;
    [(UINavigationController*)self.navigationController pushViewController:coffeeDetailTableViewContoller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoffeeMasterModel *model = self.coffees[indexPath.row];
    
    CoffeeMasterTableViewCell *cell = [self.offscreenCells objectForKey:MasterCellIdentifier];
    if (!cell) {
        cell = [[CoffeeMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterCellIdentifier];
        [self.offscreenCells setObject:cell forKey:MasterCellIdentifier];
    }
    
    // Configure cell
    [cell updateFonts];
    cell.itemNameLabel.text = model.name;
    cell.itemDescriptionLabel.text = model.shortDescription;
    
    cell.itemImageView.image = model.image;
    [cell.itemImageView invalidateIntrinsicContentSize];
    
    // setNeedsUpdateConstraints makes sure a future call to updateConstraintsIfNeeded calls updateConstraints.
    // setNeedsLayout makes sure a future call to layoutIfNeeded calls layoutSubviews.
    // When layoutSubviews is called, it also calls updateConstraintsIfNeeded.
    [cell setNeedsUpdateConstraints];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1;
    
    return height;
}

#pragma mark - Helper
- (void)callServiceForData
{
    // Request Model data from service.
    HTTPManager *httpManager = [HTTPManager sharedHTTPManager];
    [httpManager getCoffeesSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        // Create an array of objects built from JSON
        NSMutableArray *objectsMArray = [NSMutableArray array];
        for (NSDictionary *coffeeJSONDict in responseObject) {
            NSError *error = nil;
            CoffeeMasterModel *model;
            model = [MTLJSONAdapter modelOfClass:[CoffeeMasterModel class]
                                          fromJSONDictionary:coffeeJSONDict
                                                       error:&error];
            
            [objectsMArray addObject:model];
        }
        
        // Set the Model.
        self.coffees = [NSArray arrayWithArray:objectsMArray];
        
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
                                                             image = [responseObject scaleToDisplaySize:MasterImageSize];
                                                         }
                                                         
                                                         // Model
                                                         CoffeeMasterModel *model = self.coffees[indexPath.row];
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

@end
