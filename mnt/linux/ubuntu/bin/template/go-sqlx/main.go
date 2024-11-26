package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

func PrintPrettyJson(obj interface{}) {
	r, _ := json.MarshalIndent(obj, "", "  ")
	fmt.Println(string(r))
}

type record struct {
	Id   int    `db:"id"`
	Name string `db:"name"`
}

func initDB() *sqlx.DB {
	jst := time.FixedZone("Asia/Tokyo", 9*60*60)
	cfg := mysql.Config{
		User:      "foo",
		Passwd:    "bar",
		Net:       "tcp",
		Addr:      "127.0.0.1:3366",
		DBName:    "TESTDB",
		ParseTime: true,
		Loc:       jst,
	}
	dsn := cfg.FormatDSN()

	db, err := sqlx.Open("mysql", dsn)
	if err != nil {
		panic(err)
	}

	return db
}

func main() {
	db := initDB()

	var results []record
	err := db.Select(&results, `
SELECT id, name from members
;`)
	if err != nil {
		panic(err)
	}

	PrintPrettyJson(results)
}
