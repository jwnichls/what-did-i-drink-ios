// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Profile.m instead.

#import "_Profile.h"

const struct ProfileAttributes ProfileAttributes = {
	.created_at = @"created_at",
	.email = @"email",
	.firstName = @"firstName",
	.image_url = @"image_url",
	.lastName = @"lastName",
	.profile_id = @"profile_id",
	.updated_at = @"updated_at",
};

const struct ProfileRelationships ProfileRelationships = {
	.checkins = @"checkins",
};

const struct ProfileFetchedProperties ProfileFetchedProperties = {
};

@implementation ProfileID
@end

@implementation _Profile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Profile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Profile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:moc_];
}

- (ProfileID*)objectID {
	return (ProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"profile_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"profile_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic created_at;






@dynamic email;






@dynamic firstName;






@dynamic image_url;






@dynamic lastName;






@dynamic profile_id;



- (int64_t)profile_idValue {
	NSNumber *result = [self profile_id];
	return [result longLongValue];
}

- (void)setProfile_idValue:(int64_t)value_ {
	[self setProfile_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveProfile_idValue {
	NSNumber *result = [self primitiveProfile_id];
	return [result longLongValue];
}

- (void)setPrimitiveProfile_idValue:(int64_t)value_ {
	[self setPrimitiveProfile_id:[NSNumber numberWithLongLong:value_]];
}





@dynamic updated_at;






@dynamic checkins;

	
- (NSMutableSet*)checkinsSet {
	[self willAccessValueForKey:@"checkins"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"checkins"];
  
	[self didAccessValueForKey:@"checkins"];
	return result;
}
	






@end
