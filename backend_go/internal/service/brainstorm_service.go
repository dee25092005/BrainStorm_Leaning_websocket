package service

import (
	"brainstorm-backend/internal/models"
	"fmt"
	"sync"
	"time"

	"gorm.io/gorm"
)

type BrainstormService struct {
	ideas []models.Idea
	db    *gorm.DB
	mu    sync.Mutex
}

func NewBrainstormService(db *gorm.DB) *BrainstormService {
	return &BrainstormService{
		ideas: []models.Idea{},
	}
}

// ProcessMessage handles the logic and returns the message to be broadcasted
func (s *BrainstormService) ProcessMessage(msg models.WSMessage) (models.WSMessage, bool) {
	s.mu.Lock()
	defer s.mu.Unlock()

	switch msg.Type {
	case "ping":
		return models.WSMessage{Type: "pong", Payload: "Service is active"}, true

	case "new_idea":
		//create new idea object
		newID := fmt.Sprintf("%d", time.Now().UnixNano())
		//c0onvert payload to string
		content := fmt.Sprintf("%v", msg.Payload)

		idea := models.Idea{
			ID:    newID,
			Text:  content,
			Votes: 0,
		}

		//save to database
		s.ideas = append(s.ideas, idea)
		s.db.Create(&idea)
		fmt.Printf("Saved new idea id %v with content: %v\n", idea.ID, idea.Text)

		//return the new idea to be broadcasted
		return models.WSMessage{
			Type:    "idea_added",
			Payload: idea,
		}, true

	case "vote":
		id := fmt.Sprintf("%v", msg.Payload)
		var idea models.Idea
		result := s.db.Model(&idea).Where("id = ?", id).UpdateColumn("votes", gorm.Expr("votes + ?", 1))

		if result.Error != nil {
			fmt.Printf("Error updating votes for idea %v: %v\n", id, result.Error)
			return models.WSMessage{}, false
		}

		//fetch the updated idea send it back to the clients
		s.db.First(&idea, "id = ?", id)

		var updateIdea models.Idea

		return models.WSMessage{
			Type:    "vote_updated",
			Payload: updateIdea,
		}, true

	case "get_all":
		var allIdeas []models.Idea
		s.db.Order("votes desc").Find(&allIdeas)

		return models.WSMessage{
			Type:    "initial_state",
			Payload: allIdeas,
		}, true

	default:
		return models.WSMessage{}, false
	}

}
