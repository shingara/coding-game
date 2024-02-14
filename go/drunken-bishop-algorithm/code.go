package main

import (
	"bufio"
	"fmt"
	"os"
)

type ChessLine struct {
	Plot []string
}

type ChessBoard struct {
	Lines []ChessLine
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	scanner.Scan()
	fingerprint := scanner.Text()
	_ = fingerprint // to avoid unused error

	line := make([]string, 17)
	for i, _ := range line {
		line[i] = " "
	}
	fmt.Println(line)
	chessLines := make([]ChessLine, 9)
	for i, _ := range chessLines {
		chessLines[i].Plot = line
	}
	//fmt.Println(chessLines)
	chess_board := ChessBoard{Lines: chessLines}

	fmt.Println(chess_board)

	// fmt.Fprintln(os.Stderr, "Debug messages...")
	fmt.Println("+---[CODINGAME]---+")
	for i, _ := range chess_board.Lines {
		fmt.Printf("|")
		for j, _ := range chess_board.Lines[i].Plot {
			fmt.Printf(chess_board.Lines[i].Plot[j])
		}
		fmt.Printf("|\n")
	}
	fmt.Println("+-----------------+")
}
