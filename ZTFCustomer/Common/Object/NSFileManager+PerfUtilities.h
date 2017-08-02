//
//  NSFileManager.h
//  SinaPerformanceSDK
//
//  Created by wujianbo on 3/25/13.
//  Copyright (c) 2013 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

// Path utilities
NSString *spNSDocumentsFolder(void);
NSString *spNSCacheFolder(void);
NSString *spNSLibraryFolder(void);
NSString *spNSBundleFolder(void);

@interface NSFileManager (PerfUtilities)

+ (NSString*)spPathForItemNamed:(NSString *)fname inFolder:(NSString *)path;

+ (NSString*)spPathForFileInDocumentNamed:(NSString *)fname;

+ (NSString*)spPathForFileInCacheNamed:(NSString *)fname;

+ (NSString*)spPathForBundleDocumentNamed:(NSString *)fname;

+ (NSArray*)spPathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path;

+ (NSArray*)spPathsForDocumentsMatchingExtension:(NSString *)ext;

+ (NSArray*)spPathsForBundleDocumentsMatchingExtension:(NSString *)ext;

+ (BOOL)spCreateDirectoryIfNotExisted:(NSString*)pathname error:(NSError**)error;

+ (NSArray*)spFilesInFolder:(NSString *)path;

+ (BOOL)spFileExists:(NSString*)filename;

+ (BOOL)spRemoveFileAtPath:(NSString*)filePath;

@end
