#!/usr/bin/env bash


fileUnderTest="${BASH_SOURCE%/*}/../jq/main.jq"


read -d '' fourLineTests <<-'EOF' || true
negate: positive number.
"1"
negate
"-1"

negate: negative number.
"-1"
negate
"1"

lessOrEqual(x; y): true
null
lessOrEqual("49695"; "101010444")
true

lessOrEqual(x; y): false
null
lessOrEqual("101010444"; "49695")
false

lessOrEqual(.[0]; .[1]): true
["-2", "-1"]
lessOrEqual(.[0]; .[1])
true

lessOrEqual(.[0]; .[1]): true
["-2", "1"]
lessOrEqual(.[0]; .[1])
true


long_add(x; y): basic.
null
long_add("10000000000000000"; "20000000000000000")
"30000000000000000"

long_add: negative + positive
null
long_add("-2";"1")
"-1"

long_add: positive + negative
null
long_add("1";"-2")
"-1"

long_add(.[0];.[1])
["1","-2"]
long_add(.[0];.[1])
"-1"

long_add: long
null
long_add("1";"9999999999999999999999999999")
"10000000000000000000000000000"

long_add: composite
null
long_add("-9999999999999999999999999999"; long_add("1";"9999999999999999999999999999"))
"1"

long_minus(x; y): basic.
null
long_minus("10000000000000000"; "20000000000000000")
"-10000000000000000"

long_power(i): basic.
"1000"
long_power("2")
"1000000"

long_multiply(x; y): basic.
null
long_multiply("10000000000000000"; "1000")
"10000000000000000000"

long_divide(x; y): basic.
null
long_divide("10000000000000001"; "1000")
["10000000000000", "1"]

long_div(x; y): basic.
null
long_div("10000000000000000"; "1000") 
"10000000000000"

long_mod(x; y): basic.
null
long_mod("10000000000000123"; "10000000000000000") 
"123"

gcd: basic
null
gcd("2";"3")
"1"

gcd: signed
null
gcd("-2";"6")
"2"

gcd: gcd(.[0];.[1])
["7","77"]
gcd(.[0];.[1])
"7"
EOF

function testAllFourLineTests () {
	echo "$fourLineTests" | runAllFourLineTests
}


# Run tests above automatically.
# Custom tests can be added by adding new function with a name that starts with "test": function testSomething () { some test code; }
source "${BASH_SOURCE%/*}/test-runner.sh"
