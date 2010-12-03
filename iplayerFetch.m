//
//  iplayerFetch.m
//  iplayerDumpTest
//
//  Created by Colin Bell on 02/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import "playListXmlParser.h"
#import "streamXmlParser.h"
#import "rtmpdump.h"
#import "ffmpeg.h"
#import "iplayerFetch.h";

@implementation iplayerFetch

- (void)setDownloadProgressDelegate:(PDColoredProgressView *)theProgress
{
	downloadProgress = theProgress;
}

- (void)startTheBackgroundJob:(NSArray *) args {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *thePid = [args objectAtIndex:0];
	NSString *flvPath = [args objectAtIndex:1];
	NSString *mp4Path = [args objectAtIndex:2];
	[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:flvPath waitUntilDone:NO]; 
	[self getFlashFile:thePid withFlvPathName: flvPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:flvPath]){
		NSNumber *filesize = 0;
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:flvPath traverseLink:NO];
		if(fileAttributes != nil){
			filesize = [fileAttributes objectForKey:NSFileSize];
		}
		
		if([filesize longLongValue] > 1024){
			[self removeFlvWrapper:flvPath withMp4PathName:mp4Path];
		}
		[fileManager removeItemAtPath:flvPath error:NULL];
	}
	
	[fileManager release];
	[pool drain];
	//[pool release];
}

- (void)updateProgressBar:(NSString *) flvPath {  
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSNumber *filesize = 0;
    float actual = [downloadProgress progress];
	NSLog(@"progress is:%f", actual);
    if (actual < 1) {
		downloadProgress.progress = actual + 0.01;
		if([fileManager fileExistsAtPath:flvPath]){
			NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:flvPath traverseLink:NO];
			if(fileAttributes != nil){
				filesize = [fileAttributes objectForKey:NSFileSize];
				NSLog(@"filesize is:%lld", [filesize longLongValue]);
			}
		}
		else{
			filesize = 0;
			NSLog(@"filesize is:%lld", [filesize longLongValue]);
		}
	  
        //downloadProgress.progress = actual + 0.01;  
        //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgressBar:) userInfo:flvPath repeats:NO];  
		[self performSelector:@selector(updateProgressBar:) withObject:flvPath afterDelay:1.0];
	}  
	[fileManager release];
} 

- (void)beginDownload:(NSString *) thePid withDocumentsFolder:(NSString *) documentsDirectory andTempFolder:(NSString *) tempDirectory {
	NSString *flvPath = [NSString stringWithFormat:@"%@/%@.flv", tempDirectory, thePid];
	NSString *mp4Path = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, thePid];

	NSArray *extraArgs = [[NSArray alloc] initWithObjects:thePid, flvPath, mp4Path, nil];
	//[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob:) toTarget:self withObject:extraArgs];

	[self startTheBackgroundJob:extraArgs];

}

- (void)getFlashFile:(NSString *) thePid withFlvPathName:(NSString *)flvPath{
	NSString *xmlUrl = [NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/playlist/%@/",thePid];
	
	playListXmlParser * playListParser = [playListXmlParser alloc];
	NSString * streamPid = [playListParser initPlayListXMLParser:xmlUrl];
	[playListParser release];
	
	NSString *streamXmlUrl = [NSString stringWithFormat:@"http://www.bbc.co.uk/mediaselector/4/mtis/stream/%@",streamPid];
	streamXmlParser * streamParser = [streamXmlParser alloc];
	NSMutableDictionary * result = [streamParser initStreamXMLParser:streamXmlUrl];
	
	//NSLog(@"RTMPDUMP URL: %@\r\n\r\n", [streamParser getFileSize]);
	[streamParser release];
	
	
	NSString * q = [result objectForKey: @"authString"];
	NSArray * pairs = [q componentsSeparatedByString:@"&"];
	NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
	for (NSString * pair in pairs) {
		NSArray * bits = [pair componentsSeparatedByString:@"="];
		NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		[kvPairs setObject:value forKey:key];
	}
	
	//NSString * mp = [kvPairs objectForKey: @"mp"];
	//NSArray * mpItems = [mp componentsSeparatedByString:@","];
	
	static char **rt_argv;
	static int    rt_argc;
	
	rt_argc = 16;
	rt_argv = (char **)malloc(sizeof(char *) * (rt_argc));
	
	rt_argv[0] = "rtmpdump";
	rt_argv[1] = (char *)[@"-r" UTF8String];
	rt_argv[2] = (char *)[[NSString stringWithFormat:@"rtmp://%@:1935/%@?%@", [result objectForKey: @"server"],[result objectForKey: @"application"],[result objectForKey: @"authString"]] UTF8String];
	
	rt_argv[3] = (char *)[@"-a" UTF8String];
	rt_argv[4] = (char *)[[NSString stringWithFormat:@"%@?%@", [result objectForKey: @"application"],[result objectForKey: @"authString"]] UTF8String];
	
	rt_argv[5] = (char *)[@"-f" UTF8String];
	rt_argv[6] = (char *)[@"WIN 10,0,32,18" UTF8String];
	
	rt_argv[7] = (char *)[@"-W" UTF8String];
	rt_argv[8] = (char *)[@"http://www.bbc.co.uk/emp/10player.swf?revision=18269_21576" UTF8String];
	
	rt_argv[9] = (char *)[@"-p" UTF8String];
	rt_argv[10] = (char *)[[NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/console/%@", thePid] UTF8String];
	
	rt_argv[11] = (char *)[@"-y" UTF8String];
	rt_argv[12] = (char *)[[NSString stringWithFormat:@"%@", [result objectForKey: @"identifier"]] UTF8String];
			
	rt_argv[13] = (char *)[@"-o" UTF8String];
	rt_argv[14] = (char *)[flvPath UTF8String];
	
	rt_argv[15] = (char *)[@"-q" UTF8String];
	/*
	NSString * test = [NSString stringWithFormat:@"%@ %@ \"%@\" %@ \"%@\" %@ \"%@\" %@ \"%@\" %@ \"%@\" %@ \"%@\" %@ \"%@\"", 
		[NSString stringWithCString:rt_argv[0]],
		[NSString stringWithCString:rt_argv[1]],
		[NSString stringWithCString:rt_argv[2]],
		[NSString stringWithCString:rt_argv[3]],
		[NSString stringWithCString:rt_argv[4]],
		[NSString stringWithCString:rt_argv[5]],
		[NSString stringWithCString:rt_argv[6]],
		[NSString stringWithCString:rt_argv[7]],
		[NSString stringWithCString:rt_argv[8]],
		[NSString stringWithCString:rt_argv[9]],
		[NSString stringWithCString:rt_argv[10]],
		[NSString stringWithCString:rt_argv[11]],
		[NSString stringWithCString:rt_argv[12]],
		[NSString stringWithCString:rt_argv[13]],
		[NSString stringWithCString:rt_argv[14]]
	];
	
	NSLog(@"RTMPDUMP URL: %@\r\n\r\n", test);
	*/
	
	getStream(rt_argc, rt_argv);
}

-(void)removeFlvWrapper:(NSString *)flvPath withMp4PathName:(NSString *)mp4Path{
	static char **rt_argv;
	static int    rt_argc;
	
	rt_argc = 8;
	rt_argv = (char **)malloc(sizeof(char *) * (rt_argc));

	rt_argv[0] = "ffmpeg";
	rt_argv[1] = (char *)[@"-i" UTF8String];
	rt_argv[2] = (char *)[flvPath UTF8String];
	rt_argv[3] = (char *)[@"-acodec" UTF8String];
	rt_argv[4] = (char *)[@"copy" UTF8String];
	rt_argv[5] = (char *)[@"-vcodec" UTF8String];
	rt_argv[6] = (char *)[@"copy" UTF8String];
	rt_argv[7] = (char *)[mp4Path UTF8String];
	
	doConversion(rt_argc, rt_argv);
}

- (void)dealloc {
    [super dealloc];
}

@end
