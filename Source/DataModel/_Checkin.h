// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Checkin.h instead.

#import <CoreData/CoreData.h>


extern const struct CheckinAttributes {
	__unsafe_unretained NSString *checkin_id;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *updated_at;
} CheckinAttributes;

extern const struct CheckinRelationships {
	__unsafe_unretained NSString *drink;
	__unsafe_unretained NSString *profile;
	__unsafe_unretained NSString *venue;
} CheckinRelationships;

extern const struct CheckinFetchedProperties {
} CheckinFetchedProperties;

@class Drink;
@class Profile;
@class Venue;








@interface CheckinID : NSManagedObjectID {}
@end

@interface _Checkin : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CheckinID*)objectID;





@property (nonatomic, strong) NSNumber* checkin_id;



@property int64_t checkin_idValue;
- (int64_t)checkin_idValue;
- (void)setCheckin_idValue:(int64_t)value_;

//- (BOOL)validateCheckin_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* created_at;



//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated_at;



//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Drink *drink;

//- (BOOL)validateDrink:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Profile *profile;

//- (BOOL)validateProfile:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





@end

@interface _Checkin (CoreDataGeneratedAccessors)

@end

@interface _Checkin (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCheckin_id;
- (void)setPrimitiveCheckin_id:(NSNumber*)value;

- (int64_t)primitiveCheckin_idValue;
- (void)setPrimitiveCheckin_idValue:(int64_t)value_;




- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;





- (Drink*)primitiveDrink;
- (void)setPrimitiveDrink:(Drink*)value;



- (Profile*)primitiveProfile;
- (void)setPrimitiveProfile:(Profile*)value;



- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
