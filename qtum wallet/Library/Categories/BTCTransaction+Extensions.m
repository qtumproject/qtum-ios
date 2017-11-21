//
//  BTCTransaction+Extensions.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

@implementation BTCTransaction (Extensions)

- (NSString *)hexWithTime {
	return BTCHexFromData ([self computePayloadWithTime]);
}

- (NSData *)computePayloadWithTime {
	NSMutableData *payload = [NSMutableData data];

	// 4-byte version
	uint32_t ver = self.version;
	[payload appendBytes:&ver length:4];

	// varint with number of inputs
	[payload appendData:[BTCProtocolSerialization dataForVarInt:self.inputs.count]];

	// input payloads
	for (BTCTransactionInput *input in self.inputs) {
		[payload appendData:input.data];
	}

	// varint with number of outputs
	[payload appendData:[BTCProtocolSerialization dataForVarInt:self.outputs.count]];

	// output payloads
	for (BTCTransactionOutput *output in self.outputs) {
		[payload appendData:output.data];
	}

	// 4-byte lock_time
	uint32_t lt = self.lockTime;
	[payload appendBytes:&lt length:4];

	return payload;
}


- (NSData *)computeSmartContractWithBitecde:(NSData *) bitcode {
	NSMutableData *payload = [NSMutableData data];

	// 4-byte version
	uint32_t ver = self.version;
	[payload appendBytes:&ver length:4];


	NSInteger gasLimit = 2000000;
	[payload appendBytes:&gasLimit length:8];

	NSInteger gasPrice = 2;
	[payload appendBytes:&gasPrice length:8];

	// varint with number of inputs
	[payload appendData:[BTCProtocolSerialization dataForVarInt:self.inputs.count]];

	// input payloads
	for (BTCTransactionInput *input in self.inputs) {
		[payload appendData:input.data];
	}

	// varint with number of outputs
	[payload appendData:[BTCProtocolSerialization dataForVarInt:self.outputs.count]];

	// output payloads
	for (BTCTransactionOutput *output in self.outputs) {
		[payload appendData:output.data];
	}

	// 4-byte lock_time
	uint32_t lt = self.lockTime;
	[payload appendBytes:&lt length:4];


	return payload;
}

@end
