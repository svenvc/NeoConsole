Add a method to a class

add <class>
<selectorAndArguments>
<source>*
<empty line>
- add (compile) selectorAndArguments with source to (in) class

Examples

add FooBar
test1
  ^ true

- add an instance method #test1 to FooBar that returns true

add FooBar class
example1
  ^ self new

- add a class method #example1 to FooBar that creates a new instance of FooBar
