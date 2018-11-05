capturing
captureException: anException in: anEventBlock
	| event exceptionMessage |
	event := SentryEvent new.
	event message: anException description.
	exceptionMessage := anException messageText.
	exceptionMessage ifNil: [ exceptionMessage := anException description ].
	event
		exception:
			(SentryException new
				values:
					{SentryExceptionValue new
						type: anException class name;
						value: exceptionMessage;
						module: anException class package name;
						stacktrace: (self stacktraceFor: anException)}).
	anEventBlock value: event.
	^ self send: event