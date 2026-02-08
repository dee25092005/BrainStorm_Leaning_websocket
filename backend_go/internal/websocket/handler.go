package websocket

import (
	"brainstorm-backend/internal/models"
	"encoding/json"
	"log"
	"net/http"
)

func HandlerMessage(hub *Hub, rawMessage []byte) {
	var msg models.WSMessage

	//decode the json
	if err := json.Unmarshal(rawMessage, &msg); err != nil {
		log.Printf("Error decoding message: %v", err)
		return

	}

	//logic Switch
	switch msg.Type {
	case "ping":
		log.Println("Received ping message")
		//create a response
		response := models.WSMessage{
			Type:    "pong",
			Payload: "Server is alive",
		}

		hub.Broadcast <- response
	case "new_idea":
		log.Println("Received new idea message")
	}
}

func ServeWs(h *Hub, w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		return
	}
	client := &Client{Hub: h, Conn: conn, Send: make(chan []byte, 256)}
	client.Hub.Register <- client

	initialState, _ := h.Service.ProcessMessage(models.WSMessage{Type: "get_all"})
	data, _ := json.Marshal(initialState)
	client.Send <- data

	go client.WritePump()
	go client.ReadPump()
}
