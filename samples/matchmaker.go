// Servidor de emparejamiento
package main

import (
	"fmt"
	"net/http"
	"time"
)

const maxPlayers = 4

type Lobby struct {
	ID      string
	Players []string
	Created time.Time
}

func (l *Lobby) Full() bool {
	return len(l.Players) >= maxPlayers
}

func main() {
	lobby := &Lobby{ID: "eu-1", Created: time.Now()}
	http.HandleFunc("/join", func(w http.ResponseWriter, r *http.Request) {
		if lobby.Full() {
			http.Error(w, "lleno", http.StatusConflict)
			return
		}
		fmt.Fprintf(w, "ok %d\n", len(lobby.Players))
	})
	_ = http.ListenAndServe(":8080", nil)
}
