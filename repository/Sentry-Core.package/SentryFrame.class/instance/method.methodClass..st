accessing - convenience
method: aMethod methodClass: aMethodClass
	self filenameFromMethod: aMethod methodClass: aMethodClass.
	self function: aMethod selector.
	self module: aMethodClass package name asString