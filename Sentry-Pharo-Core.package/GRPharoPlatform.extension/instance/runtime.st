*Sentry-Pharo-Core
runtime
	^ Dictionary new 
		at: 'name' put: 'Pharo';
		at: 'version' put: SystemVersion current highestUpdate;
		yourself