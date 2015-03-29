//
//  UIImage+Scale.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)scaleToDisplaySize:(ImageDisplaySize)imageDisplaySize
{
    UIImage *scaledImage = nil;
    
    CGRect rect = [self createFrameForDisplaySize:imageDisplaySize usingImageSize:self.size];
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    scaledImage = [UIImage imageWithData:imageData];
    
    return scaledImage;
}

// Helper
- (CGRect)createFrameForDisplaySize:(ImageDisplaySize)displaySize usingImageSize:(CGSize)imageSize
{
    CGRect adjustedImageRect = CGRectZero;
    CGFloat const kMaxMasterImageViewFrameWidth = 150.0;
    CGFloat const kMaxDetailImageViewFrameWidth = 300.0;
    
    CGFloat maxImageFrameWidth = 0.0;
    
    if (displaySize == MasterImageSize) {
        maxImageFrameWidth = kMaxMasterImageViewFrameWidth;
    } else if (displaySize == DetailImageSize) {
        maxImageFrameWidth = kMaxDetailImageViewFrameWidth;
    }
    
    CGSize adjustedSize = CGSizeZero;
    CGFloat scaleFactor = 0.0;
    
    if (imageSize.width > maxImageFrameWidth) {
        // Scale imageView frame to maxWidth.
        scaleFactor = maxImageFrameWidth / imageSize.width;
        adjustedSize.width = imageSize.width * scaleFactor;
        adjustedSize.height = imageSize.height * scaleFactor;
    } else {
        // Use image frame as imageView frame.
        adjustedSize = imageSize;
    }
    
    adjustedImageRect = CGRectMake(0.0, 0.0, adjustedSize.width, adjustedSize.height);
    
    return adjustedImageRect;
}
@end
