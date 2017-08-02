//
//  NSFileManager.h
//  SinaPerformanceSDK
//
//  Created by wujianbo on 3/25/13.
//  Copyright (c) 2013 sina. All rights reserved.
//

#import "NSFileManager+PerfUtilities.h"

NSString *spNSDocumentsFolder(void)
{
	static NSString *documentFolder = nil;
	if (documentFolder == nil)
    {
		documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	return documentFolder;
}

NSString *spNSCacheFolder(void)
{
    static NSString *cacheFolder = nil;
	if (cacheFolder == nil)
    {
		cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	return cacheFolder;
}

NSString *spNSLibraryFolder(void)
{
	static NSString *libraryFolder = nil;
	if (libraryFolder == nil)
    {
		libraryFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	
	return libraryFolder;
}

NSString *spNSBundleFolder(void)
{
	return [[NSBundle mainBundle] bundlePath];
}

@implementation NSFileManager (Utilities)

+ (NSString *)spPathForItemNamed:(NSString *)fname inFolder:(NSString *)path
{
    return [path stringByAppendingPathComponent:fname];
}

+ (NSString *)spPathForFileInDocumentNamed:(NSString *)fname
{
	return [NSFileManager spPathForItemNamed:fname inFolder:spNSDocumentsFolder()];
}

+ (NSString *)spPathForFileInCacheNamed:(NSString *)fname
{
    return [NSFileManager spPathForItemNamed:fname inFolder:spNSCacheFolder()];
}

+ (NSString *)spPathForBundleDocumentNamed: (NSString *) fname
{
	return [NSFileManager spPathForItemNamed:fname inFolder:spNSBundleFolder()];
}

+ (NSArray *)spFilesInFolder:(NSString *)path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while ((file = [dirEnum nextObject]))
	{
		BOOL isDir;
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir) [results addObject:file];
	}
	return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *)spPathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while ((file = [dirEnum nextObject]))
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
			[results addObject:[path stringByAppendingPathComponent:file]];
	return results;
}

+ (NSArray *)spPathsForDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager spPathsForItemsMatchingExtension:ext inFolder:spNSDocumentsFolder()];
}

// Case insensitive compare
+ (NSArray *)spPathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
	return [NSFileManager spPathsForItemsMatchingExtension:ext inFolder:spNSBundleFolder()];
}


+ (BOOL)spCreateDirectoryIfNotExisted:(NSString*)pathname error:(NSError**)error
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm createDirectoryAtPath:pathname withIntermediateDirectories:YES attributes:nil error:error];
}

+ (BOOL)spRemoveFileAtPath:(NSString*)filePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
   return  [fm removeItemAtPath:filePath error:nil];
}


+ (BOOL)spFileExists:(NSString*)filename
{
    // Sanity checks
    if (filename == nil)
    {
        return NO;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filename])
    {
        return YES;
    }
    else
    {
       return NO;
    }
}


@end

