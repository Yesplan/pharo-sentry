*Sentry-Pharo-Core
framesForException: exception forClient: sentryClient

	^ exception signalerContext stack
		collect: [ :ctx | 
			| method interval lines line |
			method := ctx method.
			interval := ctx debuggerMap rangeForPC: ctx pc.
			lines := method sourceCode lines.
			line := (method sourceCode lineNumberCorrespondingToIndex: interval first).
			SentryFrame new
				method: method methodClass: method methodClass;
				lineno: line;
				contextLine: (lines at: line);
				preContext: (lines copyFrom: (1 max: (line - 5)) to: (line - 1));
				postContext: (lines copyFrom: (line + 1) to: (lines size min: (line + 5)));
				inApp: (sentryClient isMethodInApp: method methodClass: method methodClass);
				vars: (Dictionary new
						at: '_receiver' put: (ctx receiver printStringLimitedTo: 120);
						at: '_context' put: (ctx printStringLimitedTo: 120);
					yourself) ]
