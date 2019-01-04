*Sentry-GemStone-Core
runtime
	| gemStoneVersion |
	
	gemStoneVersion := 'GemStone 3'.
	Smalltalk at: #FixedPoint ifAbsent: [ gemStoneVersion := 'GemStone 2' ].
	^ Dictionary new
		at: 'name' put: 'GemStone';
		at: 'version' put: gemStoneVersion;
		yourself