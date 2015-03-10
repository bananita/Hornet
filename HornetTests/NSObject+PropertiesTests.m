#import <XCTest/XCTest.h>
#import "NSObject+Properties.h"

@interface ClassWithoutProperties : NSObject
@end

@interface ClassWithOneProperty : NSObject
@property NSInteger integer;
@end

@interface ClassWithThreeProperties : NSObject
@property NSUInteger unsignedinteger;
@property id object;
@property NSInteger integer;
@end

@protocol FirstProtocol <NSObject>
@end

@protocol SecondProtocol <NSObject>
@end

@interface ClassWithProtocolProperty : NSObject
@property id<FirstProtocol> property;
@property NSString<SecondProtocol> *objectProperty;
@end

@interface NSObject_PropertiesTests : XCTestCase
@end

@implementation NSObject_PropertiesTests

- (void)testAskingForNamesOfPropertiesOfClassWithoutThemShouldReturnEmptyArray {
    //Arrange
    ClassWithoutProperties *instance = [ClassWithoutProperties new];

    //Act
    NSArray *result = [instance namesOfProperties];

    //Assert
    XCTAssertEqualObjects([NSArray array], result);
}

- (void)testAskingForNamesOfPropertiesOfClassWithOnePropertyShouldReturnProperArray {
    //Arrange
    ClassWithOneProperty *instance = [ClassWithOneProperty new];

    //Act
    NSArray *result = [instance namesOfProperties];

    //Assert
    XCTAssertEqualObjects(@[@"integer"], result);
}

- (void)testAskingForNamesOfPropertiesOfClassWithThreePropertiesShouldReturnProperArray {
    //Arrange
    ClassWithThreeProperties *instance = [ClassWithThreeProperties new];

    //Act
    NSArray *result = [instance namesOfProperties];

    //Assert
    XCTAssertTrue([result containsObject:@"integer"]);
    XCTAssertTrue([result containsObject:@"unsignedinteger"]);
    XCTAssertTrue([result containsObject:@"object"]);
}

- (void)testAskingForProtocolOfPrimitivePropertyShouldReturnNil {
    //Arrange
    ClassWithOneProperty *instance = [ClassWithOneProperty new];

    //Act
    Protocol *result = [instance protocolOfPropertyWithName:@"integer"];

    //Assert
    XCTAssertNil(result);
}

- (void)testAskingForProtocolOfClassPropertyShouldReturnNil {
    //Arrange
    ClassWithThreeProperties *instance = [ClassWithThreeProperties new];

    //Act
    Protocol *result = [instance protocolOfPropertyWithName:@"object"];

    //Assert
    XCTAssertNil(result);
}

- (void)testAskingForProtocolOfPropertyShouldReturnIt {
    //Arrange
    ClassWithProtocolProperty *instance = [ClassWithProtocolProperty new];

    //Act
    Protocol *result = [instance protocolOfPropertyWithName:@"property"];

    //Assert
    XCTAssertEqualObjects(result, @protocol(FirstProtocol));
}

- (void)testAskingForProtocolOfPropertyWithClassAndProtocolShouldReturnIt {
    //Arrange
    ClassWithProtocolProperty *instance = [ClassWithProtocolProperty new];

    //Act
    Protocol *result = [instance protocolOfPropertyWithName:@"objectProperty"];

    //Assert
    XCTAssertEqualObjects(result, @protocol(SecondProtocol));
}

- (void)testAskingForProtocolOfPropertyThatDoesntExistsShouldReturnNil {
    //Arrange
    ClassWithProtocolProperty *instance = [ClassWithProtocolProperty new];

    //Act
    Protocol *result = [instance protocolOfPropertyWithName:@"propertyThatDoesntExists"];

    //Assert
    XCTAssertNil(result);
}

@end

@implementation ClassWithoutProperties
@end
@implementation ClassWithOneProperty
@end
@implementation ClassWithThreeProperties
@end
@implementation ClassWithProtocolProperty
@end
