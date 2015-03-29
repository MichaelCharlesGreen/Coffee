//
//  CoffeeMasterTableViewCell.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeMasterTableViewCell.h"
#import "UIFontDescriptor+HelveticaNeueLight.h"

NSString * const MasterCellIdentifier = @"MasterCellIdentifier";

// Define horizontal and vertical insets for laying out the cell.
#define kViewHorizontalInsets 15.0f
#define kViewVerticalInsets 10.0f

@interface CoffeeMasterTableViewCell ()
// Track whether the Auto Layout contrainsts have been setup.
@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) NSArray *views;
@end

@implementation CoffeeMasterTableViewCell

#pragma mark - Initializer
// Init this cell with two labels and an image view.
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return self;
    
    // Display cell Disclosure Indicator
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Adding subviews to this cell.
    [self.contentView addSubview:self.itemNameLabel]; // Name of Coffee
    [self.contentView addSubview:self.itemDescriptionLabel]; // Short description of Coffee
    [self.contentView addSubview:self.itemImageView]; // Image of coffee.
    
    // Array of contentView subviews; used to distribute and inset subviews along vertical axis.
    self.views = @[self.itemNameLabel, self.itemDescriptionLabel, self.itemImageView];
    
    [self updateFonts]; // Set Dynamic Type for labels in this cell.
    
    return self;
}

#pragma mark - Accessor
- (UILabel *)itemNameLabel
{
    if (!_itemNameLabel) _itemNameLabel = [UILabel newAutoLayoutView];
    
    // itemNameLabel to display the coffee's name.
    [_itemNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_itemNameLabel setNumberOfLines:1];
    [_itemNameLabel setTextAlignment:NSTextAlignmentLeft];
    [_itemNameLabel setTextColor:[UIColor blackColor]];
    
    return _itemNameLabel;
}

- (UILabel *)itemDescriptionLabel
{
    if (!_itemDescriptionLabel) _itemDescriptionLabel = [UILabel newAutoLayoutView];
    
    // itemDescriptionLabel to display a short description of the coffee.
    [_itemDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_itemDescriptionLabel setNumberOfLines:0]; // wrap text
    [_itemDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [_itemDescriptionLabel setTextColor:[UIColor darkGrayColor]];
    
    return _itemDescriptionLabel;
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) _itemImageView = [UIImageView newAutoLayoutView];
    
    // itemImageView to display an image of the coffee.
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return _itemImageView;
}

#pragma mark - UIView
// Since this is a custom view and we are updating constraints, we override this method.
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        if ([self.reuseIdentifier isEqualToString:MasterCellIdentifier]) {

            // itemNameLabel
            [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
                [self.itemNameLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewHorizontalInsets];

            // itemDescriptionLabel
            [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
                [self.itemDescriptionLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
            [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewHorizontalInsets];
            
            // itemImageView (specification not needed)
            [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
                [self.itemImageView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.itemImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];

            // Distribute views vertically with insets from contentView and fixed spacing between contentView-subviews.
            [self.views autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSpacing:kViewVerticalInsets insetSpacing:YES matchedSizes:NO];

            self.didSetupConstraints = YES;
        }
    }

    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews
    // have their frames set, which we need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout]; // invalidate the current layout a trigger a new layout
    [self.contentView layoutIfNeeded]; // force the layout of subivews before drawing
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame.
    // This allows the text to wrap correctly, which will allow for the calculation of an appropriate cell height.
    self.itemDescriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.itemDescriptionLabel.frame);
}

#pragma mark - Helper
- (void)updateFonts
{
    // Using Dynamic Type
    self.itemNameLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredHelveticaNeueLightFontDescriptorWithTextStyle:AppFontTextStyleCellDescription] size: 0];
    self.itemDescriptionLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredHelveticaNeueLightFontDescriptorWithTextStyle:AppFontTextStyleCellDescription] size: 0];
}

#pragma mark - check out
// Only called if a reuse identifier is set.
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.itemNameLabel.text = nil;
    self.itemDescriptionLabel.text = nil;
    self.itemImageView.image = nil;
}

@end
