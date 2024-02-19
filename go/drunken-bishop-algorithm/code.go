package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type ChessLine struct {
	Plot []string
}

type ChessBoard struct {
	Lines    []ChessLine
	Position []int
}

func makeChessBoard(start_position []int) ChessBoard {
	chessLines := make([]ChessLine, 9)
	for i, _ := range chessLines {
		line := make([]string, 17)
		for i, _ := range line {
			line[i] = " "
		}
		chessLines[i].Plot = line
	}
	//fmt.Println(chessLines)
	chessLines[start_position[1]].Plot[start_position[0]] = "S"

	return ChessBoard{
		Lines:    chessLines,
		Position: start_position,
	}
}

func printChessBoard(chessBoard ChessBoard) {
	fmt.Println("+---[CODINGAME]---+")
	for i, _ := range chessBoard.Lines {
		fmt.Printf("|")
		for j, _ := range chessBoard.Lines[i].Plot {
			fmt.Print(chessBoard.Lines[i].Plot[j])
		}
		fmt.Printf("|\n")
	}
	fmt.Println("+-----------------+")
}

func reverse[S ~[]E, E any](s S) {
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
}
func decimalToBinary(num int64, byte_need int) []int64 {
	binary := make([]int64, 0)
	for num != 0 {
		binary = append(binary, num%2)
		num = num / 2
	}
	// fmt.Fprintf(os.Stderr, "byte_need : %v\n", byte_need)
	for len(binary)%2 != 0 || len(binary) < (byte_need*2) {
		binary = append(binary, 0)
	}
	reverse(binary)
	return binary
}

func HexTodirection(hexString string) []string {
	i, err := strconv.ParseInt(hexString, 16, 64)
	if err != nil {
		fmt.Printf("%s", err)
	}
	// fmt.Fprintf(os.Stderr, "decimal : %v\n", i)
	decodedByteArray := decimalToBinary(i, len(hexString)*2)
	var result []string
	var previous int64
	var pair string

	// fmt.Fprintf(os.Stderr, "decodedByteArray : %v\n", decodedByteArray)
	for i, b := range decodedByteArray {
		if i%2 == 0 {
			previous = b
		} else {
			pair = fmt.Sprintf("%d%d", previous, b)
			result = append(result, pair)
		}
	}
	reverse(result)
	// for len(result) != 4 {
	// 	result = append(result, "00")
	// }
	return result
}

// MoveBishop move the bishop on the chessboard and mark the position with the valid value
// [".", "o", "+", "=", "*", "B", "O", "X", "@", "%", "&", "#", "/", "^"]
var ListOfSymbols = []string{".", "o", "+", "=", "*", "B", "O", "X", "@", "%", "&", "#", "/", "^"}

// Find the next symbol to use as marker
func NextMarker(current string) string {
	if current == "S" {
		return "S"
	}

	for i, symbol := range ListOfSymbols {
		if current == symbol {
			if i+2 > len(ListOfSymbols) {
				return " "
			}
			return ListOfSymbols[i+1]
		}
	}
	return "."
}

func MoveBishop(chessBoard *ChessBoard, directions []string) {
	var new_position []int // {x, y}
	for step, direction := range directions {
		if direction == "11" { //bottom right
			new_position = []int{chessBoard.Position[0] + 1, chessBoard.Position[1] + 1}
		} else if direction == "10" { // bottom left
			new_position = []int{chessBoard.Position[0] - 1, chessBoard.Position[1] + 1}
		} else if direction == "00" { // top left
			new_position = []int{chessBoard.Position[0] - 1, chessBoard.Position[1] - 1}
		} else if direction == "01" { // top right
			new_position = []int{chessBoard.Position[0] + 1, chessBoard.Position[1] - 1}
		}

		if new_position[0] > 16 {
			new_position[0] = 16
		}
		if new_position[1] > 8 {
			new_position[1] = 8
		}
		if new_position[0] < 0 {
			new_position[0] = 0
		}
		if new_position[1] < 0 {
			new_position[1] = 0
		}
		next_marker := NextMarker(chessBoard.Lines[new_position[1]].Plot[new_position[0]])
		fmt.Fprintf(os.Stderr, "step : %v, direction : %v, => new position %v : %v\n", step, direction, new_position, next_marker)
		chessBoard.Lines[new_position[1]].Plot[new_position[0]] = next_marker
		chessBoard.Position = new_position
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	scanner.Scan()
	fingerprint := scanner.Text()
	_ = fingerprint // to avoid unused error
	fmt.Fprintf(os.Stderr, "finger print : %v\n", fingerprint)

	chess_board := makeChessBoard([]int{8, 4})
	for _, hex := range strings.Split(fingerprint, ":") {
		binary := HexTodirection(hex)
		MoveBishop(&chess_board, binary)
	}
	chess_board.Lines[chess_board.Position[1]].Plot[chess_board.Position[0]] = "E"
	printChessBoard(chess_board)

	// fmt.Fprintln(os.Stderr, "Debug messages...")
}
