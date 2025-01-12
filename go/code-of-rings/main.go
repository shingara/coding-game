package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func extractSentence(io io.Reader) string {
	scanner := bufio.NewScanner(io)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	scanner.Split(bufio.ScanLines)
	scanner.Scan()
	return scanner.Text()
}

func codeOfRings(io io.Reader) string {
	magicPhrase := extractSentence(io)
	_ = magicPhrase // to avoid unused error
	return "+.>-."
}

func main() {
	action := codeOfRings(os.Stdin)
	fmt.Println(action)
}
