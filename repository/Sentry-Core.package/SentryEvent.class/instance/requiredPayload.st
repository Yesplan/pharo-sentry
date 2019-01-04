accessing - special
requiredPayload
	^ Dictionary new
		at: 'event_id' put: self eventIdString;
		at: 'timestamp' put: (self isoTimestampFor: self timestamp);
		yourself