//
//  Created by Chris Kau on 1/3/13.
//  Copyright (c) 2013 N/A. All rights reserved.
//

@interface Drink : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *recipe;
@property (nonatomic) NSArray *urls;

@property (nonatomic) NSString *created_at;
@property (nonatomic) NSString *created_by;
@property (nonatomic) NSString *updated_at;

@end
