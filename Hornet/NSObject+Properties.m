#import "NSObject+Properties.h"
#import <objc/runtime.h>

const char * property_getTypeString( objc_property_t property )
{
    const char * attrs = property_getAttributes( property );
    if ( attrs == NULL )
        return ( NULL );

    static char buffer[256];
    const char * e = strchr( attrs, ',' );
    if ( e == NULL )
        return ( NULL );

    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';

    return ( buffer );
}

@implementation NSObject (Properties)

- (NSArray *)namesOfProperties {
    unsigned int i, count = 0;
    objc_property_t * properties = class_copyPropertyList( [self class], &count );

    if ( count == 0 )
    {
        free( properties );
        return [NSArray array];
    }

    NSMutableArray * list = [NSMutableArray array];

    for ( i = 0; i < count; i++ )
        [list addObject: [NSString stringWithUTF8String: property_getName(properties[i])]];

    return [list copy];
}

- (Protocol *)protocolOfPropertyWithName:(NSString *)propertyName {
    objc_property_t property = class_getProperty( [self class], [propertyName UTF8String] );

    if (!property)
        return nil;

    NSString *protocolName =[self extractProtocolNameFromTypeString:[NSString stringWithUTF8String: property_getTypeString(property)]];
    return NSProtocolFromString(protocolName);
}

- (NSString *)extractProtocolNameFromTypeString:(NSString *)typeString {
    NSInteger begin =0,end=0;


    for (int i=0;i<strlen(typeString.UTF8String);i++) {
        char c = typeString.UTF8String[i];
        if (c=='<') begin = i;
        if (c=='>') end = i;
    }
    if (begin == 0 && end == 0) return nil;
    return [typeString substringWithRange:NSMakeRange(begin+1, end-begin-1)];
}

@end
