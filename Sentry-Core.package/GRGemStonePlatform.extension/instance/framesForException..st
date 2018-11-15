*Sentry-Core
framesForException: anException
	| level process frames maxLevel |
	level := 1.
	maxLevel := 40.
	process := GsProcess continuationFromLevel: 1.
	frames := OrderedCollection new.
	[	|  method stepPoint argAndTempNames methodLines preContextLines postContextLines |
		(level >= maxLevel)
			ifTrue: [ false ]
			ifFalse: [ (process _frameContentsAt: level)
				ifNil: [ false ]
				ifNotNil: [ :frameContents |
					method := frameContents at: 1.	
					stepPoint := (method  _lineNumberForStep: (process _localStepPointAt: level)).
					argAndTempNames := Dictionary new.
					(frameContents at: 9) keysAndValuesDo: [ :index :name |
						argAndTempNames at: (name asString) put: (self printObject: (frameContents at: 10 + index)) ].
					methodLines := method sourceString lines.
					preContextLines := methodLines copyFrom: (1 max: (stepPoint -5)) to: stepPoint - 1.
					postContextLines := methodLines copyFrom: (stepPoint + 1) to: (methodLines size min: (stepPoint + 5)).
					frames add: (Dictionary new
						at: 'method' put: method;
						at: 'methodClass' put: method inClass;
						at: 'methodLineNo' put: stepPoint asString;
						at: 'methodContextLine' put: (((method sourceString lines) at: stepPoint) replaceAll: $' with: $");
						at: 'methodVars' put: argAndTempNames;
						at: 'methodPreContext' put: (preContextLines collect: [ :line | line replaceAll: $' with: $" ]);
						at: 'methodPostContext' put: (postContextLines collect: [ :line | line replaceAll: $' with: $" ]);
						yourself).
					true ] ] ] whileTrue: [ level := level + 1 ].
	^ frames