package main

import (
	"brainstorm-backend/internal/database"
	"brainstorm-backend/internal/service"
	"brainstorm-backend/internal/websocket"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {

	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	database.InitDB()

	if database.DB == nil {
		log.Fatal("Database connection is not initialized")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	brainSvc := service.NewBrainstormService(database.DB)
	hub := websocket.NewHub(brainSvc)
	go hub.Run()

	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		websocket.ServeWs(hub, w, r)
	})

	log.Println("Server started on :" + port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
