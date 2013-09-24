// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Profile.h instead.

#import <CoreData/CoreData.h>


extern const struct ProfileAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *image_url;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *profile_id;
	__unsafe_unretained NSString *updated_at;
} ProfileAttributes;

extern const struct ProfileRelationships {
	__unsafe_unretained NSString *checkins;
} ProfileRelationships;

extern const struct ProfileFetchedProperties {
} ProfileFetchedProperties;

@class Checkin;









@interface ProfileID : NSManagedObjectID {}
@end

@interface _Profile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProfileID*)objectID;





@property (nonatomic, strong) NSDate* created_at;



//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* image_url;



//- (BOOL)validateImage_url:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* profile_id;



@property int64_t profile_idValue;
- (int64_t)profile_idValue;
- (void)setProfile_idValue:(int64_t)value_;

//- (BOOL)validateProfile_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated_at;



//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *checkins;

- (NSMutableSet*)checkinsSet;





@end

@interface _Profile (CoreDataGeneratedAccessors)

- (void)addCheckins:(NSSet*)value_;
- (void)removeCheckins:(NSSet*)value_;
- (void)addCheckinsObject:(Checkin*)value_;
- (void)removeCheckinsObject:(Checkin*)value_;

@end

@interface _Profile (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveImage_url;
- (void)setPrimitiveImage_url:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSNumber*)primitiveProfile_id;
- (void)setPrimitiveProfile_id:(NSNumber*)value;

- (int64_t)primitiveProfile_idValue;
- (void)setPrimitiveProfile_idValue:(int64_t)value_;




- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;





- (NSMutableSet*)primitiveCheckins;
- (void)setPrimitiveCheckins:(NSMutableSet*)value;


@end
