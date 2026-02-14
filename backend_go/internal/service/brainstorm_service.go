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
		db:    db,
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

		// 1. Update the database
		result := s.db.Model(&idea).Where("id = ?", id).Update("votes", gorm.Expr("votes + ?", 1))

		if result.Error != nil || result.RowsAffected == 0 {
			fmt.Printf("Vote failed for ID %v: %v\n", id, result.Error)
			return models.WSMessage{}, false
		}

		// 2. Fetch the REAL data into the 'idea' variable
		s.db.First(&idea, "id = ?", id)

		// 3. REMOVE 'var updateIdea models.Idea' (it's empty!)

		// 4. Return the 'idea' variable you just filled with data
		return models.WSMessage{
			Type:    "vote_updated",
			Payload: idea, // <--- Change this from updateIdea to idea
		}, true

	case "get_all":
		var allIdeas []models.Idea
		s.db.Order("votes desc").Find(&allIdeas)

		return models.WSMessage{
			Type:    "initial_state",
			Payload: allIdeas,
		}, true

	case "delete_idea":
		var id string
		if m, ok := msg.Payload.(map[string]interface{}); ok {
			id = fmt.Sprintf("%v", m["id"])
		} else {
			id = fmt.Sprintf("%v", msg.Payload)
		}

		fmt.Printf("Attemp to delete is ID %s\n", id)

		result := s.db.Unscoped().Delete(&models.Idea{}, "id =?", id)

		if result.Error != nil {
			fmt.Printf("Gorm error : %v", result.Error)
			return models.WSMessage{}, false
		}
		if result.RowsAffected == 0 {
			fmt.Printf("Delete failed : no row found with id %s \n", id)
			return models.WSMessage{}, false
		}

		fmt.Printf("successfully delete ID : %s\n", id)
		return models.WSMessage{
			Type:    "idea_deleted",
			Payload: id,
		}, true

	default:
		return models.WSMessage{}, false
	}

}
