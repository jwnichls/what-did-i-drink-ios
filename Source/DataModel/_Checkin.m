// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Checkin.m instead.

#import "_Checkin.h"

const struct CheckinAttributes CheckinAttributes = {
	.checkin_id = @"checkin_id",
	.created_at = @"created_at",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.notes = @"notes",
	.updated_at = @"updated_at",
};

const struct CheckinRelationships CheckinRelationships = {
	.drink = @"drink",
	.profile = @"profile",
	.venue = @"venue",
};

const struct CheckinFetchedProperties CheckinFetchedProperties = {
};

@implementation CheckinID
@end

@implementation _Checkin

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CheckIn" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CheckIn";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CheckIn" inManagedObjectContext:moc_];
}

- (CheckinID*)objectID {
	return (CheckinID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"checkin_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"checkin_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic checkin_id;



- (int64_t)checkin_idValue {
	NSNumber *result = [self checkin_id];
	return [result longLongValue];
}

- (void)setCheckin_idValue:(int64_t)value_ {
	[self setCheckin_id:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveCheckin_idValue {
	NSNumber *result = [self primitiveCheckin_id];
	return [result longLongValue];
}

- (void)setPrimitiveCheckin_idValue:(int64_t)value_ {
	[self setPrimitiveCheckin_id:[NSNumber numberWithLongLong:value_]];
}





@dynamic created_at;






@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}





@dynamic notes;






@dynamic updated_at;






@dynamic drink;

	

@dynamic profile;

	

@dynamic venue;

	






@end
