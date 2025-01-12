package main

import (
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
	result := ">............."
	if action != result {
		t.Fatalf(`parse failed = %q want match to %#q`, action, result)
	}
}
