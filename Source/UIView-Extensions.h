//
//  Created by Chris Kau
//  Copyright (c) 2012. All rights reserved.
//

@interface UIView (Extensions)

- (id)initWithParent:(UIView *)parent;
+ (id)viewWithParent:(UIView *)parent;

// position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

// setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@end


@interface UIImageView (Extensions)

- (void)setImageWithName:(NSString *)imageName;

@end
