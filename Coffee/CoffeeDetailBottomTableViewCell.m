//
//  CoffeeDetailBottomTableViewCell.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeDetailBottomTableViewCell.h"
#import "UIFontDescriptor+HelveticaNeueLight.h"
#import "Design.h"

#define kViewHorizontalInsets 15.0f
#define kViewVerticalInsets 10.0f

NSString * const BottomDetailCellIdentifier = @"BottomDetailCellIdentifier";

@interface CoffeeDetailBottomTableViewCell ()
@property (assign, nonatomic) BOOL didSetupConstraints;
@end

@implementation CoffeeDetailBottomTableViewCell

#pragma mark - Initializer
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Adding subviews.
        [self.contentView addSubview:self.itemDescriptionLabel];
        [self.contentView addSubview:self.itemImageView];
        [self.contentView addSubview:self.lastUpdatedAtLabel];
        
        [self updateFonts]; // Set Dynamic Type for labels in this cell.
    }
    
    return self;
}

#pragma mark - Accessors
- (UILabel *)itemDescriptionLabel
{
    if (!_itemDescriptionLabel) _itemDescriptionLabel = [UILabel newAutoLayoutView];
    
    [_itemDescriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_itemDescriptionLabel setNumberOfLines:0];
    [_itemDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
    [_itemDescriptionLabel setTextColor:[Design lightGrayColor]];
    
    return _itemDescriptionLabel;
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) _itemImageView = [UIImageView newAutoLayoutView];
    
    // itemImageView to display an image of the coffee.
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return _itemImageView;
}

- (UILabel *)lastUpdatedAtLabel
{
    if (!_lastUpdatedAtLabel) _lastUpdatedAtLabel = [UILabel newAutoLayoutView];
    
    [_lastUpdatedAtLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lastUpdatedAtLabel setNumberOfLines:1];
    [_lastUpdatedAtLabel setTextAlignment:NSTextAlignmentLeft];
    [_lastUpdatedAtLabel setTextColor:[Design lightGrayColor]];
    
    return _lastUpdatedAtLabel;
}

#pragma mark - UIView
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        // itemDescriptionLabel
        [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
            [self.itemDescriptionLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kViewVerticalInsets * 2];
        [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
        [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewHorizontalInsets];
        
        // itemImageView
        [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
            [self.itemImageView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.itemImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
        [self.itemImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemDescriptionLabel withOffset:kViewVerticalInsets relation:NSLayoutRelationEqual];
        
        // lastUpdatedAtLabel
        [UIView autoSetPriority:UILayoutPriorityRequired-1 forConstraints:^{
            [self.lastUpdatedAtLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.lastUpdatedAtLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewHorizontalInsets];
        [self.lastUpdatedAtLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewHorizontalInsets];
        [self.lastUpdatedAtLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemImageView withOffset:kViewVerticalInsets];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.itemDescriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.itemDescriptionLabel.frame);
}

#pragma mark - Helper
- (void)updateFonts
{
    self.itemDescriptionLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredHelveticaNeueLightFontDescriptorWithTextStyle:AppFontTextStyleCellDescription] size: 0];
    self.lastUpdatedAtLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor preferredHelveticaNeueLightItalicFontDescriptorWithTextStyle:AppFontTextStyleCellDescription] size:0];
}

@end
