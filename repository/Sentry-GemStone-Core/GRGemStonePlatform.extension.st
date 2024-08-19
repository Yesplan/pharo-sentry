Extension { #name : #GRGemStonePlatform }

{ #category : #'*Sentry-GemStone-Core' }
GRGemStonePlatform >> framesForException: exception forClient: sentryClient [

	| isGS3 includeStackTemps level process frames maxLevel frameContents |

	isGS3 := self isGemStone3.
	includeStackTemps := sentryClient includeStackTemps.
	level := 1.
	maxLevel := 40.
	process := GsProcess continuationFromLevel: 1.
	frames := OrderedCollection new.
	[ (level < maxLevel) and: [ (frameContents := process _frameContentsAt: level) notNil ] ] whileTrue: [
		| method homeMethod stepPoint argAndTempNames methodLines preContextLines postContextLines frame |
		method := frameContents at: 1.	
		homeMethod := isGS3 ifFalse: [ method ] ifTrue: [ method homeMethod ].
		stepPoint := (method  _lineNumberForStep: (process _stepPointAt: level)).
		argAndTempNames := Dictionary new.
		(frameContents at: 9) keysAndValuesDo: [ :index :name |
			| valueIndex |
			valueIndex := 10 + index.
			(includeStackTemps or: [ (name size >= 2 and: [ (name at: 1) = $. and: [ (name at: 2) = $t ] ]) not ]) ifTrue: [
				argAndTempNames
					at: name asString
					put: (valueIndex <= frameContents size ifTrue: [ self printObject: (frameContents at: valueIndex) ] ifFalse: [ '<no value>' ]) ] ].
		methodLines := method sourceString lines.
		preContextLines := methodLines copyFrom: (1 max: (stepPoint -5)) to: stepPoint - 1.
		postContextLines := methodLines copyFrom: (stepPoint + 1) to: (methodLines size min: (stepPoint + 5)).
		(frame := SentryFrame new)
			lineno: stepPoint;
			contextLine: ((method sourceString lines) at: stepPoint);
			preContext: preContextLines;
			postContext: postContextLines;
			vars: argAndTempNames.
		method inClass ifNotNil: [ :mClass |
			frame
				method: homeMethod methodClass: method inClass;
				inApp: (sentryClient isMethodInApp: homeMethod methodClass: method inClass)
		] ifNil: [
			frame filename: 'Executed Code' ].
		frames add: frame.
		level := level + 1 ].
	^ frames
]

{ #category : #'*Sentry-GemStone-Core' }
GRGemStonePlatform >> printObject: object [

	| objectSize objectClass instanceVariables numberOfInstanceVariables result |

	result := String new.

	objectSize := Reflection sizeOf: object.
	objectClass := Reflection classOf: object.
	
	result addAll: ' [oop:'.
	result addAll: (Reflection oopOf: object) asString.
	result addAll: ', size: '.
	result addAll: objectSize asString.
	result addAll: ', class: '.
	result addAll: object class name.
	result
		addAll: '] ';
		addAll: ([ object printStringLimitedTo: 50 ] on: Error do: [ :err | '<error printing object>' ]).
	^ result
]

{ #category : #'*Sentry-GemStone-Core' }
GRGemStonePlatform >> runtime [
	| gemStoneVersion |
	
	gemStoneVersion := 'GemStone 3'.
	Smalltalk at: #FixedPoint ifAbsent: [ gemStoneVersion := 'GemStone 2' ].
	^ Dictionary new
		at: 'name' put: 'GemStone';
		at: 'version' put: gemStoneVersion;
		yourself
]
