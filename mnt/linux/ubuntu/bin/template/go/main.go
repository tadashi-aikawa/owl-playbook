package main

import (
	"log"
)

func sum(x int, y int) int {
	return x + y
}

func main() {
	total := sum(1, 10)
	log.Printf("x + y = %d", total)
}
