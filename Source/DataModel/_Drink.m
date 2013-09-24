// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Drink.m instead.

#import "_Drink.h"

const struct DrinkAttributes DrinkAttributes = {
	.created_at = @"created_at",
	.drink_id = @"drink_id",
	.name = @"name",
	.recipe = @"recipe",
	.updated_at = @"updated_at",
};

const struct DrinkRelationships DrinkRelationships = {
};

const struct DrinkFetchedProperties DrinkFetchedProperties = {
};

@implementation DrinkID
@end

@implementation _Drink

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Drink" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Drink";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Drink" inManagedObjectContext:moc_];
}

- (DrinkID*)objectID {
	return (DrinkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"drink_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"drink_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic created_at;






@dynamic drink_id;



- (int64_t)drink_idValue {
	NSNumber *result = [self drink_id];
	return [result longLongValue];
}

- (void)setDrink_idValue:(int64_t)value_ {
	[self setDrink_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveDrink_idValue {
	NSNumber *result = [self primitiveDrink_id];
	return [result longLongValue];
}

- (void)setPrimitiveDrink_idValue:(int64_t)value_ {
	[self setPrimitiveDrink_id:[NSNumber numberWithLongLong:value_]];
}





@dynamic name;






@dynamic recipe;






@dynamic updated_at;











@end
