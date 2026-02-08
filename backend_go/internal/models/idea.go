package models

type Idea struct {
	ID    string `json:"id"`
	Text  string `json:"text"`
	Votes int    `json:"votes"`
}

type WSMessage struct {
	Type    string `json:"type"`
	Payload any    `json:"payload"`
}
