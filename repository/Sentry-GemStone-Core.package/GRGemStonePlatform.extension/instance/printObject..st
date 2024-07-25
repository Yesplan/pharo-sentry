*Sentry-GemStone-Core
printObject: object

	| objectSize objectClass instanceVariables numberOfInstanceVariables result |

	result := String new.

	objectSize := Reflection sizeOf: object.
	objectClass := Reflection classOf: object.
	
	result addAll: ' [oop:'.
	result addAll: (Reflection oopOf: object) asString.
	result addAll: ', size: '.
	result addAll: objectSize asString.
	result addAll: ', class: '.
	result addAll: object class name.
	result
		addAll: '] ';
		addAll: ([ object printStringLimitedTo: 50 ] on: Error do: [ :err | '<error printing object>' ]).
	^ result