tests - extraction
testLastFrameVarsStacktraceForException
	| data stacktrace frame |
	client transport onSend: [ :dict :dsn | data := dict ].
	[ Error signal: 'msg' ]
		on: Error
		do: [ :ex | stacktrace := client stacktraceFor: ex ].
	frame := stacktrace frames last.
	self
		assert: frame vars
		equals:
			{'_context'
				->
					'[ Error signal: ''msg'' ] in SentryClientTest>>testLastFrameVarsStacktraceForException'.
			'_receiver' -> 'SentryClientTest>>#testLastFrameVarsStacktraceForException'}
				asDictionary