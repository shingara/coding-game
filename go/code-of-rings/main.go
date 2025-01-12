package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"unicode"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

// Extract the sentence we want
func extractSentence(io io.Reader) string {
	scanner := bufio.NewScanner(io)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	scanner.Split(bufio.ScanLines)
	scanner.Scan() // Get online the first line no need other
	return scanner.Text()
}

// getAlphabetPosition returns the position of a letter in the alphabet (1-based index).
// It works for both uppercase and lowercase letters.
func getAlphabetPosition(letter rune) int {
	if unicode.IsLetter(letter) {
		if unicode.IsUpper(letter) {
			return int(letter - 'A' + 1)
		} else if unicode.IsLower(letter) {
			return int(letter - 'a' + 1)
		}
	}
	return -1 // Return -1 for non-alphabet characters
}

func chooseChar(char rune) []rune {
	var result []rune
	position := getAlphabetPosition(char)
	if position > (27 / 2) {
		for i := 0; i < (27 - position); i++ {
			result = append(result, '-')
		}
	} else {
		for i := 0; i < position; i++ {
			result = append(result, '+')
		}
	}
	return result
}

// Generate the full exercice
func codeOfRings(io io.Reader) string {
	magicPhrase := extractSentence(io)
	var result []rune
	for _, char := range magicPhrase {
		result = append(result, chooseChar(char)...)
		result = append(result, rune('.'))
		result = append(result, rune('>'))
	}

	// Remove the last run because it's a excedent >
	return string(result[:len(result)-1])
}

func main() {
	action := codeOfRings(os.Stdin)
	fmt.Println(action)
}
