baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [
			spec
				package: 'Sentry-Core' .
			spec group: 'Core' with: #('Sentry-Core').
			spec
				group: 'default'
				with: #('Sentry-Core') ].
			
	spec 
		for: #(#'pharo6.x' #'pharo7.x')
		do: [ 
			spec package: 'Sentry-Core'
				with: [ spec includes: #('Sentry-Pharo-Core') ] ].
			
	spec
		for: #'gemstone'
		do: [ spec 
			spec
				package: 'Sentry-Core'
				with: [ spec requires: #('Sentry-GemStone-Core') ] ]