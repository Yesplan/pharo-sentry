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
				with: #('Sentry-Core') ]