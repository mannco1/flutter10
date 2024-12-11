package models

type User struct {
	UserId    int    `db:"user_id" json:"user_id"`
	Username  string `db:"username" json:"username"`
	Email     string `db:"email" json:"email"`
	Password  string `db:"password_hash" json:"password_hash"`
	ImageURL  string `db:"image" json:"image"`
	CreatedAt string `db:"created_at" json:"created_at"`
	Phone     string `db:"phone" json:"phone"`
}
