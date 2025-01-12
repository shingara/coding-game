# TODO: Need check if really Works

package main

import (
	"bufio"
	"fmt"
	"os"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

type Round struct {
	line int
	col  int
	id   int
}

type Tower struct {
	x     int
	y     int
	id    string
	round int
}

type Map struct {
	w      int
	h      int
	lines  []string
	towers []Tower
	rounds []Round
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	var W int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &W)

	var H int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &H)

	for i := 0; i < H; i++ {
		scanner.Scan()
		line := scanner.Text()
		_ = line // to avoid unused error
	}

	// fmt.Fprintln(os.Stderr, "Debug messages...")
	fmt.Println("answer") // Write answer to stdout
}
