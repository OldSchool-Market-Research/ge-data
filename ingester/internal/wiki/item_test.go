package wiki

import (
	"encoding/json"
	"testing"
)

// A missing limit means the Wiki doesn't know it. Reading it as 0 zeroed every recipe
// that buys the item, so it must stay nil all the way to the database.
func TestItemLimitUnknownIsNil(t *testing.T) {
	var items []Item
	raw := `[{"id":26372,"name":"Nihil horn"},{"id":1,"name":"Null","limit":null},{"id":26231,"name":"Nihil shard","limit":30000}]`
	if err := json.Unmarshal([]byte(raw), &items); err != nil {
		t.Fatal(err)
	}
	if items[0].Limit != nil || items[1].Limit != nil {
		t.Errorf("unknown limits must be nil: %v %v", items[0].Limit, items[1].Limit)
	}
	if items[2].Limit == nil || *items[2].Limit != 30000 {
		t.Errorf("known limit: %v", items[2].Limit)
	}
}
