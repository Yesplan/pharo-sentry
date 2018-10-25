tests - extraction
testLastFrameStacktraceForException
	| data stacktrace frame |
	client transport onSend: [ :dict :dsn | data := dict ].
	[ Error signal: 'msg' ]
		on: Error
		do: [ :ex | stacktrace := client stacktraceFor: ex ].
	frame := stacktrace frames last.
	self
		assert: frame filename
		equals: 'Sentry-Tests.package/SentryClientTest.class/instance/testLastFrameStacktraceForException.st'.
	self assert: frame function equals: #testLastFrameStacktraceForException.
	self assert: frame module equals: 'Sentry-Tests'.
	self assert: frame lineno equals: 4.
	self assert: frame contextLine equals: '	[ Error signal: ''msg'' ]'