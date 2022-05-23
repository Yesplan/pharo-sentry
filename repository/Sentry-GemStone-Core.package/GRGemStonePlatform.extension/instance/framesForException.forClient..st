*Sentry-GemStone-Core
framesForException: exception forClient: sentryClient

	| isGS3 level process frames maxLevel frameContents |

	isGS3 := self isGemStone3.
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
			argAndTempNames at: (name asString) put: (self printObject: (frameContents at: 10 + index)) ].
		methodLines := method sourceString lines.
		preContextLines := methodLines copyFrom: (1 max: (stepPoint -5)) to: stepPoint - 1.
		postContextLines := methodLines copyFrom: (stepPoint + 1) to: (methodLines size min: (stepPoint + 5)).
		(frame := SentryFrame new)
			lineno: stepPoint asString;
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