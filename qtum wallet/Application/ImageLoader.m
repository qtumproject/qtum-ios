//
//  ImageLoader.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AFNetworking.h"


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


- (AFHTTPRequestOperationManager *)operationManager {
	if (!_operationManager) {
		_operationManager = [[AFHTTPRequestOperationManager alloc] init];
		_operationManager.responseSerializer = [AFImageResponseSerializer serializer];
	};
	return _operationManager;
}


#pragma mark - Set Up

- (void)setUp {

	NSArray *pathList = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = pathList[0];
	NSString *cacheTemp = [cachePath stringByAppendingPathComponent:@"/temp"];
	self.cacheTempPath = cacheTemp;
	[self createDirAtPath:cacheTemp];
}


- (NSString *)localPathToFileWithUrl:(NSString *) url {

	NSString *lastComponent = [url lastPathComponent];
	NSString *localPath = [_cacheTempPath stringByAppendingPathComponent:lastComponent];
	if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
		return localPath;
	else
		return nil;
}


- (void)getImageWithUrl:(NSString *) url andSize:(CGSize) size withResultHandler:(void (^)(UIImage *image)) complete {

	if ([url isKindOfClass:[NSNull class]]) {
		complete (nil);
		return;
	}

	__weak __typeof (self) weakSelf = self;

	NSString *localPath = [self localPathToFileWithUrl:url];
	if (localPath) {
		UIImage *img = [UIImage imageWithContentsOfFile:localPath];
		complete (img);
	} else {
		[self.operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
			if ([responseObject isKindOfClass:[UIImage class]]) {

				dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

					UIImage *img = responseObject;

					float scaleFactor;

					if (img.size.width > img.size.height) {

						scaleFactor = img.size.width / size.width;
					} else {

						scaleFactor = img.size.height / size.height;
					}

					float newHeight = img.size.height * scaleFactor;
					float newWidth = img.size.width * scaleFactor;

					UIGraphicsBeginImageContext (CGSizeMake (newHeight, newWidth));
					CGContextRef context = UIGraphicsGetCurrentContext ();
					CGContextDrawImage (context, CGRectMake (0, 0, 1, 1), [img CGImage]);
					UIGraphicsEndImageContext ();

					[weakSelf saveFileWithUrl:url andFile:img];

					dispatch_sync (dispatch_get_main_queue (), ^{
						complete (img);
					});
				});
			} else {
				complete (nil);
			}
		}                  failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
			complete (nil);
		}];
	}
}


- (void)createDirAtPath:(NSString *) path {
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

- (void)saveFileWithUrl:(NSString *) url andFile:(id) file {

	NSString *lastComponent = [url lastPathComponent];
	NSString *localPath = [_cacheTempPath stringByAppendingPathComponent:lastComponent];
	if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
		[[NSFileManager defaultManager] createFileAtPath:localPath contents:nil attributes:nil];
	}

	NSError *err = nil;
	NSData *data = UIImagePNGRepresentation (file);
	[data writeToFile:localPath atomically:YES];
	if (err != nil) {
		DLog(@"We have an error.");
	}
}

+ (UIImage *)imageWithImage:(UIImage *) image scaledToSize:(CGSize) newSize {
	//UIGraphicsBeginImageContext(newSize);
	// In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
	// Pass 1.0 to force exact pixel size.
	UIGraphicsBeginImageContextWithOptions (newSize, NO, 0.0);
	[image drawInRect:CGRectMake (0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext ();
	UIGraphicsEndImageContext ();
	return newImage;
}

@end
