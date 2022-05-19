extraction
stacktraceFor: exception

	| frames |

	frames := GRPlatform current framesForException: exception forClient: self.
	^ SentryStacktrace new frames: frames reversed asArray
