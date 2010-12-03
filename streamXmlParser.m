//
//  streamXmlParser.m
//  iplayerDumpTest
//
//  Created by Colin Bell on 02/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import "streamXmlParser.h"


@implementation streamXmlParser

- (NSMutableDictionary *) initStreamXMLParser:(NSString *) theUrl {
	[self parseXMLFileAtURL:theUrl];
	return(result);
}

- (NSString *) getFileSize{
	return(fileSize);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	//NSLog(@"found file and started parsing");
	
}

- (void)parseXMLFileAtURL:(NSString *)URL{	
	streamType = @"";
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [xmlParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [xmlParser setShouldProcessNamespaces:YES];
    [xmlParser setShouldReportNamespacePrefixes:YES];
    [xmlParser setShouldResolveExternalEntities:NO];
	
    [xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	if (currentElement) {
		[currentElement release];
		currentElement = nil;
	}
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"media"]) {
		streamType = [attributeDict objectForKey:@"service"];
		if([streamType isEqualToString:@"iplayer_streaming_h264_flv_high"]){
			fileSize = [attributeDict objectForKey:@"media_file_size"];
		}
	}
	
	if ([elementName isEqualToString:@"media"]) {
		if([streamType isEqualToString:@"iplayer_streaming_h264_flv_high"]){
			result = [[NSMutableDictionary alloc] init];
			application = [[NSMutableString alloc] init];
			authString = [[NSMutableString alloc] init];
			identifier = [[NSMutableString alloc] init];
			server = [[NSMutableString alloc] init];
		}
	}
	
	if ([elementName isEqualToString:@"connection"]) {
		if([streamType isEqualToString:@"iplayer_streaming_h264_flv_high"]){
			NSString * supplier = [attributeDict objectForKey:@"supplier"];
			if([supplier isEqualToString:@"limelight"]){
				[result setObject:[attributeDict objectForKey:@"application"] forKey:@"application"];
				[result setObject:[attributeDict objectForKey:@"authString"] forKey:@"authString"];
				[result setObject:[attributeDict objectForKey:@"identifier"] forKey:@"identifier"];
				[result setObject:[attributeDict objectForKey:@"server"] forKey:@"server"];
			}
		}
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"all done!");
	//NSLog(@"hits array has %d items", [result count]);
	[xmlParser release];
}

/* END XML PARSING ROUTINES */

- (void)dealloc {
    [super dealloc];
}


@end
