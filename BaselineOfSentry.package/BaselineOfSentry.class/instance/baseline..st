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
			spec
				package: 'Sentry-Pharo-Core';
				package: 'Sentry-Core'
					with: [ spec requires: #('Sentry-Pharo-Core') ]].
			
	spec
		for: #'gemstone'
		do: [
			spec 
				package: 'Sentry-GemStone-Core';
				package: 'Sentry-Core'
					with: [ spec requires: #('Sentry-GemStone-Core') ] ]