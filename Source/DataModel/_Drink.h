// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Drink.h instead.

#import <CoreData/CoreData.h>


extern const struct DrinkAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *drink_id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *recipe;
	__unsafe_unretained NSString *updated_at;
} DrinkAttributes;

extern const struct DrinkRelationships {
} DrinkRelationships;

extern const struct DrinkFetchedProperties {
} DrinkFetchedProperties;








@interface DrinkID : NSManagedObjectID {}
@end

@interface _Drink : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DrinkID*)objectID;





@property (nonatomic, strong) NSDate* created_at;



//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* drink_id;



@property int64_t drink_idValue;
- (int64_t)drink_idValue;
- (void)setDrink_idValue:(int64_t)value_;

//- (BOOL)validateDrink_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recipe;



//- (BOOL)validateRecipe:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated_at;



//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;






@end

@interface _Drink (CoreDataGeneratedAccessors)

@end

@interface _Drink (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSNumber*)primitiveDrink_id;
- (void)setPrimitiveDrink_id:(NSNumber*)value;

- (int64_t)primitiveDrink_idValue;
- (void)setPrimitiveDrink_idValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveRecipe;
- (void)setPrimitiveRecipe:(NSString*)value;




- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;




@end
