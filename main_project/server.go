package main

import (
    "fmt"
    "log"
    "math/rand"
    "net/http"
    "sync"
    "time"
)

var (
    currentColor = "#ffffff"
    mu           sync.Mutex
    messages     = []string{
        "Слава Україні!",
        "Героям слава!",
        "Україна понад усе!",
        "Разом до перемоги!",
    }
)

func main() {
    rand.Seed(time.Now().UnixNano())

    // API маршрути
    http.HandleFunc("/random", randomHandler)
    http.HandleFunc("/color", colorHandler)

    // Статичні файли
    fs := http.FileServer(http.Dir("./static"))
    http.Handle("/", fs)

    log.Println("Сервер запущено на :7001")
    log.Fatal(http.ListenAndServe(":7001", nil))
}

func randomHandler(w http.ResponseWriter, r *http.Request) {
    msg := messages[rand.Intn(len(messages))]
    fmt.Fprint(w, msg)
}

func colorHandler(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
    case http.MethodGet:
        mu.Lock()
        defer mu.Unlock()
        fmt.Fprint(w, currentColor)
    case http.MethodPost:
        buf := make([]byte, r.ContentLength)
        r.Body.Read(buf)
        mu.Lock()
        currentColor = string(buf)
        mu.Unlock()
        fmt.Fprint(w, "ok")
    default:
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    }
}
