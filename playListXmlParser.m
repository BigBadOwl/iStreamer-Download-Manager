//
//  playListXmlParser.m
//  iplayerDumpTest
//
//  Created by Colin Bell on 02/12/2010.
//  Copyright 2010 GateWest. All rights reserved.
//

#import "playListXmlParser.h"


@implementation playListXmlParser

- (NSString *) initPlayListXMLParser:(NSString *) theUrl {
	[self parsePlayListXMLFileAtURL:theUrl];
	return(currentTitle);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	//NSLog(@"found file and started parsing");
	
}

- (void)parsePlayListXMLFileAtURL:(NSString *)URL
{	
	NSURL *xmlURL = [NSURL URLWithString:URL];
	xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[xmlParser setDelegate:self];
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
	if ([elementName isEqualToString:@"mediator"]) {
		currentTitle = [attributeDict objectForKey:@"identifier"];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[xmlParser release];
}

- (void)dealloc {
    [super dealloc];
}


@end
