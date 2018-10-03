Evaluate a Pharo expression

eval <expression>
<expression>*
<empty line>
- evaluate a multi line expression and show the result

Eval is normally the default command, no need to type 'eval'

eval 1+2

- evaluate the expression 1+2

(1 to: 10) collect: [ :each |
  each * each ]

- evaluate the multi line expression, doubling the numbers 1 to 10 in a collection