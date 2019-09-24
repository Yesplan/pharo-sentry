formatting
isoTimestampFor: aDateTime
	| utc |
	utc := aDateTime asUTC.
	^ String
		streamContents: [ :aStream | 
			utc printYMDOn: aStream withLeadingSpace: false.
			aStream nextPut: $T.
			aStream nextPutAll: (utc hour asString padded: #left to: 2 with: $0);
				nextPut: $:; 
				nextPutAll: (utc minute asString padded: #left to: 2 with: $0);
				nextPut: $:;
				nextPutAll: (utc second rounded asString padLeftTo: 2 with: $0). ]