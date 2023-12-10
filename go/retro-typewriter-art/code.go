package main

import "fmt"
import "os"
import "bufio"
import "strconv"

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Buffer(make([]byte, 1000000), 1000000)

    split := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		advance, token, err = bufio.ScanWords(data, atEOF)
        //fmt.Printf("%s\n", token)
		if err == nil && token != nil {
			_, err = strconv.ParseInt(string(token), 10, 32)
		}
		return advance, token, err
	}
    scanner.Split(split) 
    for scanner.Scan() {
      fmt.Printf("%s\n", scanner.Text())
    }
}