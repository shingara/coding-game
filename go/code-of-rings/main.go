package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"unicode"
)

var CurrentChar = make([]rune, 30)

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
	if letter == ' ' {
		return 0
	}
	if unicode.IsLetter(letter) {
		if unicode.IsUpper(letter) {
			return int(letter - 'A' + 1)
		} else if unicode.IsLower(letter) {
			return int(letter - 'a' + 1)
		}
	}
	return 0 // Return -1 for non-alphabet characters
}

func chooseChar(char rune, previousChar rune) []rune {
	var result []rune
	position := getAlphabetPosition(char)
	current_position := getAlphabetPosition(previousChar)
	// fmt.Println("position", position)
	// fmt.Println("current_position", current_position)
	delta := (position - current_position + 27) % 27
	// fmt.Println("delta", delta)
	if delta > (27 / 2) {
		for i := 0; i < (27 - delta); i++ {
			result = append(result, '-')
		}
	} else {
		for i := 0; i < delta; i++ {
			result = append(result, '+')
		}
	}
	return result
}

// Generate the full exercice
func codeOfRings(io io.Reader) string {
	// Fill the slice with space
	for i := range CurrentChar {
		CurrentChar[i] = ' '
	}

	magicPhrase := extractSentence(io)
	var result []rune
	for j, char := range magicPhrase {
		index := j % 30
		result = append(result, chooseChar(char, CurrentChar[index])...)
		CurrentChar[index] = char
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
