extraction
stacktraceFor: exception

	^ [
		| frames |

		frames := GRPlatform current framesForException: exception forClient: self.
		SentryStacktrace new
			frames: frames reversed asArray;
			yourself
	] on: Error do: [ :error |
		SentryStacktraceErrorNotification new
			tracedException: exception;
			tracingError: error;
			signal: ('Could not create SentryStacktrace for an exception of class {1}' format: { exception class name }) ]
