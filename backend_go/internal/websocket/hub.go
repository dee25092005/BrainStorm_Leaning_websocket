package websocket

import (
	"brainstorm-backend/internal/models"
	"brainstorm-backend/internal/service"
	"encoding/json"
	"log"
	"sync"
)

type Hub struct {
	// Registered clients.
	Clients map[*Client]bool
	// Inbound messages from the clients.
	Broadcast chan models.WSMessage
	// Register requests from the clients.
	Register chan *Client
	// Unregister requests from clients.
	Unregister chan *Client

	//services
	Service *service.BrainstormService

	Mu sync.Mutex
}

// NewHub initializes a new Hub instance with the necessary channels and client map.
func NewHub(s *service.BrainstormService) *Hub {
	return &Hub{
		Broadcast:  make(chan models.WSMessage),
		Register:   make(chan *Client),
		Unregister: make(chan *Client),
		Service:    s,
		Clients:    make(map[*Client]bool),
	}
}

func (h *Hub) Run() {
	for {
		select {
		case client := <-h.Register:
			h.Mu.Lock()
			h.Clients[client] = true
			h.Mu.Unlock()
		case Client := <-h.Unregister:
			h.Mu.Lock()
			if _, ok := h.Clients[Client]; ok {
				delete(h.Clients, Client)
				close(Client.Send)
			}
			h.Mu.Unlock()
		case message := <-h.Broadcast:
			log.Printf("Broadcasting message: %s", message.Type)
			for client := range h.Clients {
				data, _ := json.Marshal(message)
				client.Send <- data
			}
		}
	}
}
