package main

import "testing"

func TestWriteDirectiveWithNl(t *testing.T) {
	directive := "nl"
	result := writeDirective(directive)
	if result != "\n" {
		t.Errorf("Expected %s, got %s", "\n", result)
	}
}

func TestWriteDirectiveWith4z(t *testing.T) {
	directive := "4z"
	result := writeDirective(directive)
	if result != "zzzz" {
		t.Errorf("Expected %s, got %s", "\n", result)
	}
}

func TestWriteDirectiveWithOnlyNumber(t *testing.T) {
	directive := "44"
	result := writeDirective(directive)
	if result != "4444" {
		t.Errorf("Expected %s, got %s", "\n", result)
	}
}

func TestWriteDirectiveWithMoreThan10(t *testing.T) {
	directive := "14z"
	result := writeDirective(directive)
	if result != "zzzzzzzzzzzzzz" {
		t.Errorf("Expected %s, got %s", "\n", result)
	}
}

func TestWriteDirectiveWithMoreThan35Equal(t *testing.T) {
	directive := "35="
	result := writeDirective(directive)
	if result != "===================================" {
		t.Errorf("Expected %s, got %s", "===================================================", result)
	}
}

func TestWriteDirectiveWithspchar(t *testing.T) {
	directive := "4sp"
	result := writeDirective(directive)
	if result != "    " {
		t.Errorf("Expected %s, got %s", "\n", result)
	}
}

func TestConvertSpace(t *testing.T) {
	result := convert("sp")
	if result != " " {
		t.Errorf("Expected %s, got %s", " ", string(result))
	}
}

func TestConvertBs(t *testing.T) {
	result := convert("bS")
	if result != "\\" {
		t.Errorf("Expected %s, got %s", " ", string(result))
	}
}

func TestConvertSingleQuote(t *testing.T) {
	result := convert("sQ")
	if result != "'" {
		t.Errorf("Expected %s, got %s", " ", string(result))
	}
}

func TestConvertNewLine(t *testing.T) {
	result := convert("nl")
	if result != "\n" {
		t.Errorf("Expected %s, got %s", " ", string(result))
	}
}

func TestConvertEndOfLine(t *testing.T) {
	result := convert("e\n")
	if result != "e" {
		t.Errorf("Expected %s, got %s", "e", string(result))
	}
}
