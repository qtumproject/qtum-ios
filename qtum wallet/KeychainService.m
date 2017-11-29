//
//  KeychainService.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "KeychainService.h"
#import "FXKeychain.h"

@interface KeychainService ()

@property (strong, nonatomic) NSString* service;

@end

static NSString *touchIDIdentifire = @"TouchID";

@implementation KeychainService

- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
        _service = bundleID;
    }
    return self;
}

- (BOOL)setObject:(id) object forKey:(id) key {
    
    return [[FXKeychain defaultKeychain] setObject:object forKey:key];
}

- (id)objectForKey:(id)key {
    
    return [[FXKeychain defaultKeychain] objectForKey:key];
}

- (void)removeObjectForKey:(id) key {
    
    [[FXKeychain defaultKeychain] removeObjectForKey:key];
}

- (void)deleteTouchIdString {
    
    NSDictionary *query = @{
                            (id)kSecClass: (id)kSecClassGenericPassword,
                            (id)kSecAttrService: [self.service stringByAppendingString:touchIDIdentifire]
                            };
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        OSStatus status = SecItemDelete ((__bridge CFDictionaryRef)query);
        
        NSString *errorString = [self keychainErrorToString:status];
        NSString *message = [NSString stringWithFormat:@"SecItemDelete status: %@", errorString];
        
        DLog(@"%@", message);
    });
}


- (void)addTouchIdString:(NSString *_Nonnull) touchIDString {
    
    if (!SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0")) {
        return;
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create (0);
    
    NSDictionary *query = @{
                            (id)kSecClass: (id)kSecClassGenericPassword,
                            (id)kSecAttrService: [self.service stringByAppendingString:touchIDIdentifire]
                            };
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemDelete ((__bridge CFDictionaryRef)query);
        
        NSString *errorString = [self keychainErrorToString:status];
        NSString *message = [NSString stringWithFormat:@"SecItemDelete status: %@", errorString];
        DLog(@"%@", message);
        dispatch_semaphore_signal (semaphore);
    });
    
    dispatch_semaphore_wait (semaphore, DISPATCH_TIME_FOREVER);
    
    CFErrorRef error = NULL;
    
    // Should be the secret invalidated when passcode is removed? If not then use kSecAttrAccessibleWhenUnlocked
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags (kCFAllocatorDefault,
                                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                                     kSecAccessControlTouchIDAny, &error);
    if (sacObject == NULL || error != NULL) {
        
        return;
    }
    
    /*
     We want the operation to fail if there is an item which needs authentication so we will use
     `kSecUseNoAuthenticationUI`.
     */
    NSData *secretPasswordTextData = [touchIDString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *attributes = @{
                                 (id)kSecClass: (id)kSecClassGenericPassword,
                                 (id)kSecAttrService: [self.service stringByAppendingString:touchIDIdentifire],
                                 (id)kSecValueData: secretPasswordTextData,
                                 (id)kSecUseAuthenticationUI: (id)kSecUseAuthenticationUIAllow,
                                 (id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                 };
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSStatus status = SecItemAdd ((__bridge CFDictionaryRef)attributes, nil);
        
        NSString *message = [NSString stringWithFormat:@"SecItemAdd status: %@", [self keychainErrorToString:status]];
        
        DLog(@"%@", message);
    });
}

- (void)touchIDString:(void (^)(NSString *string, NSError *error)) handler {
    
    NSDictionary *query = @{
                            (id)kSecClass: (id)kSecClassGenericPassword,
                            (id)kSecAttrService: [self.service stringByAppendingString:touchIDIdentifire],
                            (id)kSecReturnData: @YES,
                            (id)kSecUseOperationPrompt: @"Authenticate to access service password",
                            };
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFTypeRef dataTypeRef = NULL;
        NSString *message;
        
        OSStatus status = SecItemCopyMatching ((__bridge CFDictionaryRef)(query), &dataTypeRef);
        if (status == errSecSuccess) {
            NSData *resultData = (__bridge_transfer NSData *)dataTypeRef;
            
            NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            
            message = [NSString stringWithFormat:@"Result: %@\n", result];
            handler (result, nil);
        } else {
            handler (nil, [NSError new]);
        }
    });
}

- (NSString *)keychainErrorToString:(OSStatus) error {
    NSString *message = [NSString stringWithFormat:@"%ld", (long)error];
    
    switch (error) {
        case errSecSuccess:
            message = @"success";
            break;
            
        case errSecDuplicateItem:
            message = @"error item already exists";
            break;
            
        case errSecItemNotFound :
            message = @"error item not found";
            break;
            
        case errSecAuthFailed:
            message = @"error item authentication failed";
            break;
            
        default:
            break;
    }
    
    return message;
}


@end
