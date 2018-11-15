*Sentry-Core
framesForException: anException
	^ anException signalerContext stack
		collect: [ :ctx | 
			| method interval lines line |
			method := ctx method.
			interval := ctx debuggerMap rangeForPC: ctx pc.
			lines := method sourceCode lines.
			line := (method sourceCode lineNumberCorrespondingToIndex: interval first).
			Dictionary new
				at: 'method' put: method;
				at: 'methodClass' put: method methodClass;
				at: 'methodContextLine' put: (lines at: line);
				at: 'methodPreContext' put: (lines copyFrom: (1 max: (line - 5)) to: (line - 1));
				at: 'methodPostContext' put: (lines copyFrom: (line + 1) to: (lines size min: (line + 5)));
				at: 'methodLineNo' put: line;
				at: 'methodVars' put: 
					(Dictionary new
						at: '_receiver' put: (ctx receiver printStringLimitedTo: 120);
						at: '_context' put: (ctx printStringLimitedTo: 120);
					yourself);
				yourself ].