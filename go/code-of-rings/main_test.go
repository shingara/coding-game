package main

import (
	"reflect"
	"strings"
	"testing"
)

// for a valid return value.
func Test_extractSentence(t *testing.T) {
	name := "AZ"
	reader := strings.NewReader(name)
	magic_phrase := extractSentence(reader)
	if magic_phrase != name {
		t.Fatalf(`parse failed = %q want match to %#q`, magic_phrase, name)
	}
}

func Test_01(t *testing.T) {
	name := "AZ"
	reader := strings.NewReader(name)
	action := codeOfRings(reader)
	if action != "+.>-." {
		t.Fatalf(`parse failed = %q want match to %#q`, action, "+.>-.")
	}
}

func Test_02(t *testing.T) {
	name := "MINAS"
	reader := strings.NewReader(name)
	action := codeOfRings(reader)
	result := "+++++++++++++.>+++++++++.>-------------.>+.>--------."
	if action != result {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_chooseCharToA(t *testing.T) {
	name := 'A'
	var result []rune
	result = append(result, '+')
	action := chooseChar(name, ' ')
	if !reflect.DeepEqual(action, result) {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_chooseCharToB(t *testing.T) {
	name := 'B'
	var result []rune
	for i := 0; i < 2; i++ {
		result = append(result, '+')
	}
	action := chooseChar(name, ' ')
	if !reflect.DeepEqual(action, result) {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_chooseCharToZ(t *testing.T) {
	name := 'Z'
	var result []rune
	for i := 0; i < 1; i++ {
		result = append(result, '-')
	}
	action := chooseChar(name, ' ')
	if !reflect.DeepEqual(action, result) {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_moreThan30(t *testing.T) {
	name := "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB"
	reader := strings.NewReader(name)
	action := codeOfRings(reader)
	result := "+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+.>+."
	if action != result {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_getAlphabetPosition(t *testing.T) {
	name := 'A'
	result := 1
	action := getAlphabetPosition(name)
	if action != result {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}

func Test_getAlphabetPositionSpace(t *testing.T) {
	name := ' '
	result := 0
	action := getAlphabetPosition(name)
	if action != result {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}
