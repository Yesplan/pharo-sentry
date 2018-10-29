extraction
stacktraceFor: anException
	| frames |
	frames := (GRPlatform current framesForException: anException)
		collect: [ :frame | 
			| method methodClass |
			method := frame at: 'method'.
			methodClass := frame at: 'methodClass'.
			SentryFrame new
				method: method methodClass: methodClass;
				lineno: (frame at: 'methodLineNo');
				contextLine: (frame at: 'methodContextLine');
				preContext: (frame at: 'methodPreContext');
				postContext: (frame at: 'methodPostContext');
				inApp: (self isMethodInApp: method methodClass: methodClass);
				vars: (frame at: 'methodVars') ].

	^ SentryStacktrace new frames: frames reversed asArray