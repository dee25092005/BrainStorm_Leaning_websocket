package websocket

import (
	"brainstorm-backend/internal/models"
	"encoding/json"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

type Client struct {
	Hub  *Hub
	Conn *websocket.Conn
	Send chan []byte
}

func (c *Client) ReadPump() {
	defer func() {
		c.Hub.Unregister <- c
		c.Conn.Close()
	}()

	for {
		_, raw, err := c.Conn.ReadMessage()
		if err != nil {
			break
		}

		var msg models.WSMessage
		json.Unmarshal(raw, &msg)

		//hand over the message to the hub for processing

		response, shouldbroadcast := c.Hub.Service.ProcessMessage(msg)
		if shouldbroadcast {
			c.Hub.Broadcast <- response
		}
	}
}

// WritePump sends messages from the hub to the client
func (c *Client) WritePump() {
	for message := range c.Send {
		c.Conn.WriteMessage(websocket.TextMessage, message)
	}
	c.Conn.WriteMessage(websocket.CloseMessage, []byte{})
}
