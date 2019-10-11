baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [
			spec
				baseline: 'Grease'
        		with: [ 
					spec
						loads: #('Core');
						repository: 'github://SeasideSt/Grease:v1.4.x/repository' ].
			spec
				package: 'Sentry-Core'
				with: [ spec requires: 'Grease' ].
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