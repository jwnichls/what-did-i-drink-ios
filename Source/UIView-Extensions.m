//
//  Created by Chris Kau
//  Copyright (c) 2012. All rights reserved.
//

#import "UIView-Extensions.h"

@implementation UIView (Extensions)

- (id)initWithParent:(UIView *)parent
{
	self = [self initWithFrame:parent.frame];
	if (self == nil) { return nil; }

    self.userInteractionEnabled = YES;

	[parent addSubview:self];

	return self;
}

+ (id)viewWithParent:(UIView *)parent
{
    return [[self alloc] initWithParent:parent];
}

- (CGPoint)position
{
    return self.frame.origin;
}

- (void)setPosition:(CGPoint)position
{
    CGRect frame = self.frame;
    frame.origin = position;
    self.frame = frame;
}

- (CGFloat)x { return self.frame.origin.x; };

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y { return self.frame.origin.y; };

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGSize)size { return self.frame.size; };

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width { return self.frame.size.width; };

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height { return self.frame.size.height; };

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end


@implementation UIImageView (Extensions)

- (void)setImageWithName:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
    [self sizeToFit];
//    self.frame = CGRectMake(0.0, 0.0, self.image.size.width, self.image.size.height);
}

@end
