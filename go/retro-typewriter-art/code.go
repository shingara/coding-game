package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

/**

Use the provided recipe to create a recognizable image.

Chunks in the recipe are separated by a space.
Each chunk will tell you either
nl meaning NewLine (aka Carriage Return)
~or~
how many of the character and what character

For example:
4z means zzzz
1{ means {
10= means ==========
5bS means \\\\\ (see Abbreviations list below)
27 means 77
123 means 333333333333
(If a chunk is composed only of numbers, the character is the last digit.)

So if part of the recipe is
2* 15sp 1x 4sQ nl
...that tells you to show
**               x''''
and then go to a new line.


Abbreviations used:
sp = space
bS = backSlash \
sQ = singleQuote '
and
nl = NewLine

 **/

func convert(character string) (result string) {
	if character == "sp" {
		return " "
	} else if character == "bS" {
		return "\\"
	} else if character == "sQ" {
		return "'"
	} else if character == "nl" {
		return "\n"
	}
	return strings.Trim(character, "\n") // If the character is not an abbreviation, return the
}

func writeDirective(directive string) (result string) {
	if directive == "nl" {
		return "\n"
	}

	numeric_regexp := regexp.MustCompile(`\d*`)
	number := numeric_regexp.FindString(directive)
	nb, _ := strconv.Atoi(number)
	character := convert(string(directive[len(number):]))
	if character == "" {
		character = string(number[len(number)-1])
		nb, _ = strconv.Atoi(number[:len(number)-1])
	}
	for i := 0; i < nb; i++ {
		result += character
	}
	fmt.Fprintf(os.Stderr, "Number: %s, Character: %s\n", number, character)

	return result
}

func main() {
	// Get the recipe from the user
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')
	directives := strings.Split(line, " ")

	for _, directive := range directives {
		// Parse the directive
		// If the directive is a number, add it to the current number
		// If the directive is a character, add it to the current character
		// If the directive is "nl", print a newline
		// If the directive is "~", print the current character the current number of times
		fmt.Fprintf(os.Stderr, "%s\n", directive)
		fmt.Fprintf(os.Stderr, writeDirective(directive))
		fmt.Printf("%s", writeDirective(directive))
	}

}
