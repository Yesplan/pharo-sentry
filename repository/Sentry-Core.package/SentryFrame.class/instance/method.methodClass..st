accessing - convenience
method: method methodClass: methodClass

	self filenameFromMethod: method methodClass: methodClass.
	self function: (String streamContents: [ :stream |
		stream nextPutAll: methodClass name; nextPutAll: '>>#'; nextPutAll: method selector ]).
	self module: (methodClass package ifNotNil: [ :packageInfo | packageInfo name asString ] ifNil: [ methodClass category ])
