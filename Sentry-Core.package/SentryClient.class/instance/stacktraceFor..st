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
				lineno: (frame at: 'methodLineNo');
				contextLine: (frame at: 'methodContextLine');
				inApp: (self isMethodInApp: method methodClass: methodClass);
				vars: (frame at: 'methodVars') ].
	^ SentryStacktrace new frames: frames reversed asArray