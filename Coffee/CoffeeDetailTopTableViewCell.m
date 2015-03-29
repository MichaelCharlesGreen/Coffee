//
//  CoffeeDetailTopTableViewCell.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeDetailTopTableViewCell.h"
#import "UIFontDescriptor+HelveticaNeueLight.h"
#import "Design.h"

#define kViewHorizontalInsets 15.0f
#define kViewVerticalInsets 10.0f

NSString * const TopDetailCellIdentifier = @"TopDetailCellIdentifier";

@interface CoffeeDetailTopTableViewCell ()
@property (assign, nonatomic) BOOL didSetupConstraints;
@end

@implementation CoffeeDetailTopTableViewCell

#pragma mark - Initializer
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Adding subviews.
        [self.contentView addSubview:self.itemNameLabel];
        
        [self updateFonts]; // Set Dynamic Type for labels in this cell.
    }
    
    return self;
}

#pragma mark - Accessors
- (UILabel *)itemNameLabel
{
    if (!_itemNameLabel) _itemNameLabel = [UILabel newAutoLayoutView];
    
    [_itemNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_itemNameLabel setNumberOfLines:1];
    [_itemNameLabel setTextAlignment:NSTextAlignmentLeft];
    [_itemNameLabel setTextColor:[Design darkGrayColor]];
    
    return _itemNameLabel;
}

#pragma mark - UIView
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        if ([self.reuseIdentifier isEqualToString:TopDetailCellIdentifier]) {
            
            // nameLabel
            [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
                [self.itemNameLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kViewVerticalInsets];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kViewVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
            [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewHorizontalInsets];
            
            self.didSetupConstraints = YES;
        }
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

#pragma mark - Helper
- (void)updateFonts
{
    self.itemNameLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredHelveticaNeueLightFontDescriptorWithTextStyle:AppFontTextStyleCellLargeName] size: 0];
}

@end
