//
//  STFileCache.m
//  SimpleTidbits
//
//  Created by Jason Gregori on 9/29/09.
//  Copyright 2009 Jason Gregori. All rights reserved.
//

#import "STFileCache.h"
#import <UIKit/UIKit.h>

#define kSTFileCacheTimeoutInterval			10
#define kSTFileCacheFolderName				@"STFramework File Cache"

static NSString				*st_cacheFolderPath		= nil;
static NSInteger			st_numberOfDaysToKeepFiles	= 7;

// connections being downloaded: key = path, object = connection
static NSMutableDictionary	*st_connections			= nil;

static NSMutableSet			*st_filesDownloaded		= nil;
static NSMutableSet			*st_filesToSave			= nil;


@interface STFileCache ()
@property (nonatomic, assign)	BOOL		fileWasCached;

+ (NSString *)pathForURL:(NSURL *)url;

/*
 we handle all downloads with the class instead of the instance.
 this is because if an instance is deallocated before we have finished 
 downloading, we may want to finish the download. in fact that is the default.
 But maybe we don't if it's a large file or something...
 */
+ (void)startDownloadFor:(STFileCache *)fileCache;

/*
 if a fileCache is dealloced, the class needs to know so it may stop downloading
 the file if needed and clean up some stuff.
 */
+ (void)endDownloadFor:(STFileCache *)fileCache;

/*
 Called right before the quit, this cleans everything up
 */
+ (void)finalize;

- (void)failed;
- (void)success:(NSData *)data;

@end


@implementation STFileCache
@synthesize delegate = _delegate, path = _path, url = _url,
			networkNamespace = _networkNamespace,
			fileWasCached = _fileWasCached, done = _done, data = _data,
			successful = _successful,
			continueDownloadEvenIfTerminated = _continueDownloadEvenIfTerminated,
			context = _context;

#pragma mark Class Initialize and Finalize Methods

+ (void)initialize
{
	// make sure this only gets called once for this class
	if (self != [STFileCache class])
	{
		return;
	}
	
	// check if user has set a custom cache day limit
	NSNumber	*newLimit	= [[[NSBundle mainBundle] infoDictionary] valueForKey:@"STFileCacheDaysToKeepFiles"];
	if (newLimit)
	{
		st_numberOfDaysToKeepFiles	= [newLimit integerValue];
	}
	
	// get cache folder
	NSArray			*paths		= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	st_cacheFolderPath	= [[[paths objectAtIndex:0] stringByAppendingPathComponent:kSTFileCacheFolderName] retain];
	
	// check if exists
	if (![[NSFileManager defaultManager] fileExistsAtPath:st_cacheFolderPath])
	{
		// if not, create it
		NSError		*error		= nil;
		if (![[NSFileManager defaultManager] createDirectoryAtPath:st_cacheFolderPath
									   withIntermediateDirectories:YES
														attributes:nil
															 error:&error])
		{
			[NSException raise:@"STFileCache Could Not Create File Cache Folder Exception"
						format:@"%@", error]; 
		}
	}
	
	// find all the files that are currently in the cache
	NSError		*error		= nil;
	NSArray		*fileNames	= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:st_cacheFolderPath
																		   error:&error];
	if (!fileNames)
	{
		[NSException raise:@"STFileCache Could Not Access Files in File Cache Folder Exception"
					format:@"%@", error];
	}
	
	// add them to a running list
	st_filesDownloaded	= [[NSMutableSet alloc] initWithCapacity:[fileNames count]];
	for (NSString *fileName in fileNames)
	{
		[st_filesDownloaded addObject:[st_cacheFolderPath stringByAppendingPathComponent:fileName]];
	}
	
	// create st_filesToSave
	st_filesToSave		= [[NSMutableSet alloc] init];
	
	// create st_connections
	st_connections		= [[NSMutableDictionary alloc] init];
	
	// we need to be notified of application quiting
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(finalize)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
}

+ (void)finalize
{
	if (!st_cacheFolderPath)
	{
		// must have already finalized
		return;
	}
	
	// delete all the files that haven't been used recently
	
	// get only files that haven't been touched
	[st_filesDownloaded minusSet:st_filesToSave];
	
	// get current date to see how old files are
	// (we want to save files that weren't used but aren't that old)
	NSDate		*currentDate		= [[NSDate alloc] init];
	
	// delete anything that wasn't used during this run AND is older than out limit
	for (NSString *filePath in st_filesDownloaded)
	{
		// check if it is older than our limit
		NSError		*error		= nil;
		NSDate		*fileLastModifiedDate	= [[[NSFileManager defaultManager]
												attributesOfItemAtPath:filePath
												error:&error]
											   valueForKey:NSFileModificationDate];
		if (error)
		{
			NSLog(@"STFileCache Finalizing Error: Could not get the attributes of the file at path \"%@\".", filePath);
		}
		else if ([currentDate timeIntervalSinceDate:fileLastModifiedDate]
				  > 60*60*24*st_numberOfDaysToKeepFiles)
		{
			// if the file is older than our limit, delete it
			[[NSFileManager defaultManager] removeItemAtPath:filePath
													   error:&error];
			if (error)
			{
				NSLog(@"STFileCache Finalizing Error: Could not delete file at path \"%@\".", filePath);
			}
		}
	}
	
	[currentDate release];
	
	// release global variables
	[st_connections release];
	st_connections		= nil;
	
	[st_filesDownloaded release];
	st_filesDownloaded	= nil;
	
	[st_filesToSave release];
	st_filesToSave		= nil;
	
	[st_cacheFolderPath release];
	st_cacheFolderPath	= nil;
	
	// stop getting notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Instance Methods

- (id)initWithURL:(NSString *)url
{
	return [self initWithURL:url networkNamespace:nil];
}

- (id)initWithURL:(NSString *)url networkNamespace:(NSString *)networkNamespace
{
	if (self = [super init])
	{
		self.continueDownloadEvenIfTerminated	= YES;
		_networkNamespace	= [networkNamespace copy];
		if (url)
		{
			_url		= [[NSURL alloc] initWithString:url];
		}
		if (self.url)
		{
			_path		= [[STFileCache pathForURL:self.url] retain];
		}
	}
	return self;
}

- (void)dealloc
{
	[STFileCache endDownloadFor:self];
	[_url release];
	[_path release];
	[_context release];
	[_data release];
	[_networkNamespace release];
	
	[super dealloc];
}

- (void)start
{
	if (!self.url)
	{
		[[STNetworkIndicator sharedNetworkIndicator] checkNetworkUsageForNamespace:self.networkNamespace];
		[self failed];
		return;
	}
	
	[STFileCache startDownloadFor:self];
	
	return;
}

- (BOOL)downloaded
{
	return [st_filesDownloaded containsObject:self.path];
}

- (void)failed
{
	_done		= YES;
	_successful	= NO;
	[self.delegate fileCacheDidFail:self];
}

- (void)success:(NSData *)data
{
	_done		= YES;
	_successful	= YES;
	
	if (!data)
	{
		// load data
		data	= [NSData dataWithContentsOfFile:self.path];
	}
	
	[self.delegate fileCache:self didFinishWithData:data];
}

#pragma mark -
#pragma mark Class Downloading Methods

/*
 we handle all downloads with the class instead of the instance.
 this is because if an instance is deallocated before we have finished 
 downloading, we may want to finish the download. in fact that is the default.
 But maybe we don't if it's a large file or something...
 */
+ (void)startDownloadFor:(STFileCache *)fileCache
{
	// check if file was already downloaded
	if ([st_filesDownloaded containsObject:fileCache.path])
	{
		// it is already downloaded
		// add it to the save list, if not already there
		if (![st_filesToSave containsObject:fileCache.path])
		{
			[st_filesToSave addObject:fileCache.path];
			
			// mark the modification date of the file so we know the last
			// time it was used
			[[NSFileManager defaultManager] setAttributes:
			 [NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate]
											 ofItemAtPath:fileCache.path
													error:NULL];
		}
		
		fileCache.fileWasCached	= YES;
		[[STNetworkIndicator sharedNetworkIndicator] checkNetworkUsageForNamespace:fileCache.networkNamespace];
		[fileCache success:nil];
		return;
	}
	
	// show it's network indicator
	[[STNetworkIndicator sharedNetworkIndicator] incrementNetworkUsageForNamespace:fileCache.networkNamespace];
	
	// check if the file is already being downloaded
	STSimpleURLConnection	*connection		= [st_connections objectForKey:fileCache.path];
	if (connection)
	{
		// the file is already being downloaded
		// add fileCache to the waiting list
		// connection context is a special non retaining mutable set
		[connection.context addObject:fileCache];
		
		return;
	}
	
	// else, start a new download
	
	// add to save files
	[st_filesToSave addObject:fileCache.path];
	
	// create request
	NSURLRequest	*request		= [[NSURLRequest alloc] initWithURL:fileCache.url
												   cachePolicy:NSURLRequestReloadIgnoringCacheData
											   timeoutInterval:kSTFileCacheTimeoutInterval];
	connection		= [[STSimpleURLConnection alloc] initWithRequest:request];
	connection.delegate	= self;
	[request release];
	
	if (!connection)
	{
		// there was some kind of error
		[[STNetworkIndicator sharedNetworkIndicator] decrementNetworkUsageForNamespace:fileCache.networkNamespace];
		[fileCache failed];
		return;
	}
	
	// save the path to the fileCache
	connection.subContext	= fileCache.path;
	
	// set up wait list
	// this is a special set that does not retain anything
	NSMutableSet	*waitList	= (NSMutableSet *)CFSetCreateMutable(NULL,
																	 0,
																	 NULL);
	[waitList addObject:fileCache];
	connection.context	= waitList;
	[waitList release];
	
	[st_connections setValue:connection forKey:fileCache.path];
	
	[connection start];
	[connection release];

	return;
}

/*
 if a fileCache is dealloced, the class needs to know so it may stop downloading
 the file if needed and clean up some stuff.
 */
+ (void)endDownloadFor:(STFileCache *)fileCache
{
	// check if it is still downloading
	STSimpleURLConnection	*connection		= [st_connections valueForKey:fileCache.path];
	if (!connection)
	{
		// no longer being used
		return;
	}
	
	// otherwise, remove it from the waiting cache
	NSMutableSet	*waitList	= connection.context;
	[waitList removeObject:fileCache];
	
	// dec its networkNamespace
	[[STNetworkIndicator sharedNetworkIndicator] decrementNetworkUsageForNamespace:fileCache.networkNamespace];
	
	if ([waitList count] == 0)
	{
		// if this was the fileCache waiting, check if we should stop the connection
		if (!fileCache.continueDownloadEvenIfTerminated)
		{
			// stop connection
			[st_connections removeObjectForKey:fileCache.path];
		}
	}
	
	return;
}

#pragma mark Other Class Methods

+ (NSString *)pathForURL:(NSURL *)url
{
	NSString		*path		= [st_cacheFolderPath stringByAppendingPathComponent:
								   [[NSNumber numberWithUnsignedInteger:
									 [[url absoluteString] hash]]
									stringValue]];
	NSString		*ext		= [[url absoluteString] pathExtension];
	if ([ext length] > 0)
	{
		return [path stringByAppendingPathExtension:ext];
	}
	return path;
}

#pragma mark -
#pragma mark Class Delegate Methods

+ (void)simpleURLConnectionDidFinishLoading:(STSimpleURLConnection *)connection
{
	// save the file
	// check if there is a file already there
	if ([[NSFileManager defaultManager] fileExistsAtPath:connection.subContext])
	{
		// delete old file
		[[NSFileManager defaultManager] removeItemAtPath:connection.subContext
												   error:NULL];
	}
	
	// save
	[[NSFileManager defaultManager] createFileAtPath:connection.subContext
											contents:connection.data
										  attributes:nil];
	
	// mark downloaded
	[st_filesDownloaded addObject:connection.subContext];
	
	// retain all the fileCaches, we don't want them to be dealloced before we're done
	NSSet		*fileCaches		= [connection.context copy];
	[fileCaches makeObjectsPerformSelector:@selector(retain)];
	
	// tell fileCaches its finished
	for (STFileCache *fileCache in connection.context)
	{
		[[STNetworkIndicator sharedNetworkIndicator] decrementNetworkUsageForNamespace:fileCache.networkNamespace];
		[fileCache success:connection.data];
	}
	
	// erase traces of fileCaches
	connection.context		= nil;
	
	// delete connection
	// be careful for releasing subContext while removing
	[connection retain];
	[st_connections removeObjectForKey:connection.subContext];
	[connection release];
	
	// get rid of fileCaches
	[fileCaches makeObjectsPerformSelector:@selector(release)];
	[fileCaches release];
}

+ (void)simpleURLConnection:(STSimpleURLConnection *)connection didFailWithError:(NSError *)error
{
	// retain all the fileCaches, we don't want them to be dealloced before we're done
	NSSet		*fileCaches		= [connection.context copy];
	[fileCaches makeObjectsPerformSelector:@selector(retain)];
	
	// tell fileCaches its finished
	for (STFileCache *fileCache in connection.context)
	{
		[[STNetworkIndicator sharedNetworkIndicator] decrementNetworkUsageForNamespace:fileCache.networkNamespace];
		[fileCache failed];
	}
	
	// erase traces of fileCaches
	connection.context		= nil;
	
	// delete connection
	// be careful for releasing subContext while removing
	[connection retain];
	[st_connections removeObjectForKey:connection.subContext];
	[connection release];
	
	// get rid of fileCaches
	[fileCaches makeObjectsPerformSelector:@selector(release)];
	[fileCaches release];	
}


@end
