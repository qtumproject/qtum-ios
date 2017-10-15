//
//  ImageLoader.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AFNetworking.h"
#import "ImageLoader.h"


@interface ImageLoader ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (strong, nonatomic) NSString *cacheTempPath;


@end

@implementation ImageLoader

- (instancetype)init {
    
    self = [super init];

    if (self != nil) {
        [self setUp];
    }
    return self;
}

#pragma mark - Lazy Getter


- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] init];
        _operationManager.responseSerializer = [AFImageResponseSerializer serializer];
    };
    return _operationManager;
}


#pragma mark - Set Up


- (void)setUp
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = pathList[0];
    NSString *cacheTemp = [cachePath stringByAppendingPathComponent:@"/temp"];
    self.cacheTempPath = cacheTemp;
    [self createDirAtPath:cacheTemp];
}


- (NSString *)localPathToFileWithUrl:(NSString *)url
{
    NSString *lastComponent = [url lastPathComponent];
    NSString *localPath = [_cacheTempPath stringByAppendingPathComponent:lastComponent];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
        return localPath;
    else
        return nil;
}


-(void)getImageWithUrl:(NSString*)url withResultHandler:(void(^)(UIImage* image)) complete{
    if ([url isKindOfClass:[NSNull class]]) {
        complete(nil);
        return;
    }
    NSString* localPath = [self localPathToFileWithUrl:url];
    if (localPath) {
        UIImage* img = [UIImage imageWithContentsOfFile:localPath];
        complete(img);
    } else {
        [self.operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if ([responseObject isKindOfClass:[UIImage class]]) {
                [self saveFileWithUrl:url andFile:responseObject];
                complete(responseObject);
            } else {
                complete(nil);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            complete(nil);
        }];
    }
}


- (void)createDirAtPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
}

//- (void)createDir
//{
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cacheDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath = [cacheDirectory stringByAppendingPathComponent:@"/temp"];
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//}

- (void)saveFileWithUrl:(NSString *)url andFile:(id)file
{
    NSString *lastComponent = [url lastPathComponent];
    NSString *localPath = [_cacheTempPath stringByAppendingPathComponent:lastComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        [[NSFileManager defaultManager] createFileAtPath:localPath contents:nil attributes:nil];
    }

    NSError *err = nil;
    NSData *data = UIImagePNGRepresentation(file);
    [data writeToFile:localPath atomically:YES];
    if (err != nil) {
        DLog(@"We have an error.");
    }
}


@end
