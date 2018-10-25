extraction
stacktraceFor: anException
	| frames |
	frames := (GRPlatform current framesForException: anException)
		collect: [ :frame | 
			| method ctx methodClass |
			method := frame at: 'method'.
			ctx := frame at: 'context'.
			methodClass := frame at: 'methodClass'.
			SentryFrame new
				method: method methodClass: methodClass;
				code: (frame at: 'methodSource') start: (frame at: 'methodStart');
				inApp: (self isMethodInApp: method methodClass: methodClass);
				vars: (Dictionary new 
					at: '_receiver' put: (ctx receiver printStringLimitedTo: 120);
					at: '_context' put: (ctx printStringLimitedTo: 120);
					yourself)].
	^ SentryStacktrace new frames: frames reversed asArray