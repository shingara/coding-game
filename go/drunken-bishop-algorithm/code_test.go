package main

import (
	"reflect"
	"testing"
)

func TestHexToDirection(t *testing.T) {
	directive := "F"
	result := HexTodirection(directive)
	want := []string{"11", "11"}
	want[0] = "11"
	want[1] = "11"
	if reflect.DeepEqual(result, want) == false {
		t.Errorf("Expected %v, got %v\n", want, result)
	}
}

func TestHexToDirectionWithSeveralChar(t *testing.T) {
	directive := "FC"
	result := HexTodirection(directive)
	want := []string{"00", "11", "11", "11"} // Need to be reverse
	if reflect.DeepEqual(result, want) == false {
		t.Errorf("Expected %v, got %v\n", want, result)
	}
}

func TestHexToDirection7c(t *testing.T) {
	directive := "7c"
	result := HexTodirection(directive)
	want := []string{"00", "11", "11", "01"} // Need to be reverse
	if reflect.DeepEqual(result, want) == false {
		t.Errorf("Expected %v, got %v\n", want, result)
	}
}

func TestHexToDirection25(t *testing.T) {
	directive := "25"
	result := HexTodirection(directive)
	want := []string{"01", "01", "10", "00"} // Need to be reverse
	if reflect.DeepEqual(result, want) == false {
		t.Errorf("Expected %v, got %v\n", want, result)
	}
}

func TestMoveBishop11(t *testing.T) {
	board := makeChessBoard([]int{8, 4})
	move := []string{"11"} // move to Bottom Right
	MoveBishop(&board, move)
	if board.Lines[4+1].Plot[8+1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[4+1].Plot[8+1])
	}
}

func TestMoveBishop10(t *testing.T) {
	board := makeChessBoard([]int{8, 4})
	move := []string{"10"} // move to bottom left
	MoveBishop(&board, move)
	if board.Lines[4+1].Plot[8-1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[4+1].Plot[8-1])
	}
}

func TestMoveBishop00(t *testing.T) {
	board := makeChessBoard([]int{8, 4})
	move := []string{"00"} // move to top left
	MoveBishop(&board, move)
	if board.Lines[4-1].Plot[8-1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[4-1].Plot[8-1])
	}
}

func TestMoveBishop01(t *testing.T) {
	board := makeChessBoard([]int{8, 4})
	move := []string{"01"} // move to top right
	MoveBishop(&board, move)
	if board.Lines[4-1].Plot[8+1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[4-1].Plot[8+1])
	}
}

func TestMoveBishop00OnEdge(t *testing.T) {
	board := makeChessBoard([]int{0, 4})
	move := []string{"00"} // move to top left
	MoveBishop(&board, move)
	if board.Lines[4-1].Plot[0] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[4-1].Plot[0])
	}
}

func TestMoveBishop01OnEdge(t *testing.T) {
	board := makeChessBoard([]int{16, 1})
	move := []string{"01"} // move to top right
	MoveBishop(&board, move)
	if board.Lines[0].Plot[16] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[0].Plot[16])
	}
}

func TestMoveBishop11OnEdge(t *testing.T) {
	board := makeChessBoard([]int{0, 8})
	move := []string{"11"} // move to bottom right
	MoveBishop(&board, move)
	if board.Lines[8].Plot[1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[1].Plot[8])
	}
}

func TestMoveBishop10OnEdge(t *testing.T) {
	board := makeChessBoard([]int{2, 8})
	move := []string{"10"} // move to bottom left
	MoveBishop(&board, move)
	if board.Lines[8].Plot[2-1] != "." {
		t.Errorf("Expected ., got %v\n", board.Lines[8].Plot[2-1])
	}
}

func TestMoveBishopSeveralTime(t *testing.T) {
	board := makeChessBoard([]int{8, 4})
	move := []string{"11"} // move to Bottom Right
	for _, symbol := range []string{".", "o", "+", "=", "*", "B", "O", "X", "@", "%", "&", "#", "/", "^"} {
		MoveBishop(&board, move)
		newPosition := []int{8 + 1, 4 + 1}
		if board.Lines[newPosition[1]].Plot[newPosition[0]] != symbol {
			t.Errorf("Expected %v, got %v\n", symbol, board.Lines[newPosition[1]].Plot[newPosition[0]])
		}

		if board.Position[0] != newPosition[0] || board.Position[1] != newPosition[1] {
			t.Errorf("Expected %v, got %v\n", newPosition, board.Position)
		}
		board.Position = []int{8, 4}
	}
}

func TestNextMarkerNotChangeIfS(t *testing.T) {
	result := NextMarker("S")
	want := "S"
	if result != want {
		t.Errorf("Expected %v, got %v\n", want, result)
	}
}
