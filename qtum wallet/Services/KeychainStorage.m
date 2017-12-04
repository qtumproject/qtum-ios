//
//  KeychainStorage.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "KeychainStorage.h"
#import "SAMKeychain.h"

@interface KeychainStorage ()

@property (strong, nonatomic) NSString* service;

@end

@implementation NSObject (KeychainPropertyListCoding)

- (id)Keychain_propertyListRepresentation {
    return self;
}

@end

@implementation KeychainStorage

- (instancetype)initWithService:(NSString*) service {
    
    self = [super init];
    if (self) {
        _service = service;
    }
    return self;
}

- (BOOL)setObject:(id) object forKey:(id)key {
    
    NSError *error = nil;
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = self.service;
    query.account = [key description];
    query.passwordData = [self encodeObject:object];
    [query save:&error];
    
    if ([error code] == errSecItemNotFound) {

        NSLog(@"Password not found");
        return NO;
    } else if (error != nil) {
        NSLog(@"Some other error occurred: %@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

- (id)objectForKey:(id)key {
    
    NSError *error = nil;
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = self.service;
    query.account = [key description];
    [query fetch:&error];
    
    if ([error code] == errSecItemNotFound) {
        DLog(@"Password not found");
    } else if (error != nil) {
        DLog(@"Some other error occurred: %@", [error localizedDescription]);
    }
    
    id resultObject = [self decodeData:query.passwordData];
    
    return resultObject;
}


- (BOOL)removeObjectForKey:(id) key {
    
    return [SAMKeychain deletePasswordForService:self.service account:[key description]];
}

#pragma mark - Decoding/Encoding

-(id)decodeData:(NSData*) data {
    
    if (data) {
        id object = nil;
        NSError *error = nil;
        NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
        
        //check if data is a binary plist
        if ([data length] >= 6 && !strncmp ("bplist", data.bytes, 6)) {
            //attempt to decode as a plist
            object = [NSPropertyListSerialization propertyListWithData:data
                                                               options:NSPropertyListImmutable
                                                                format:&format
                                                                 error:&error];
            
            if ([object respondsToSelector:@selector (objectForKey:)] && [(NSDictionary *)object objectForKey:@"$archiver"]) {
                //data represents an NSCoded archive
                //parse as archive
                object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
        if (!object || format != NSPropertyListBinaryFormat_v1_0) {
            //may be a string
            object = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (!object) {
            DLog(@"Keychain failed to decode data");
        }
        return object;
    } else {
        //no value found
        return nil;
    }
}

-(NSData*)encodeObject:(id) object {
    
    NSData *data = nil;
    NSError *error = nil;
    if ([(id)object isKindOfClass:[NSString class]]) {
        //check that string data does not represent a binary plist
        NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
        if (![object hasPrefix:@"bplist"] || ![NSPropertyListSerialization propertyListWithData:[object dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:NSPropertyListImmutable
                                                                                         format:&format
                                                                                          error:NULL]) {
            //safe to encode as a string
            data = [object dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    //if not encoded as a string, encode as plist
    if (object && !data) {
        data = [NSPropertyListSerialization dataWithPropertyList:[object Keychain_propertyListRepresentation]
                                                          format:NSPropertyListBinaryFormat_v1_0
                                                         options:0
                                                           error:&error];
        
        if (!data) {
            data = [NSKeyedArchiver archivedDataWithRootObject:object];
        }
    }
    
    return data;
}


@end
