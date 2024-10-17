alias Backend.Accounts.Role
alias Backend.Accounts.User
alias Backend.WorkingTime.Workingtime
alias Backend.Time.Clock

# DELETE EXISTING DATA

# Delete users first
Backend.Repo.delete_all(User)

# Delete roles next
Backend.Repo.delete_all(Role)

# Reset sequences
Backend.Repo.query("ALTER SEQUENCE roles_id_seq RESTART")
Backend.Repo.query("ALTER SEQUENCE users_id_seq RESTART")
Backend.Repo.query("ALTER SEQUENCE workingtime_id_seq RESTART")
Backend.Repo.query("ALTER SEQUENCE clocks_id_seq RESTART")

# INSERT ROLES

role1 = Backend.Repo.insert!(%Role{category: "Employee"})
role2 = Backend.Repo.insert!(%Role{category: "Manager"})
role3 = Backend.Repo.insert!(%Role{category: "General Manager"})

# INSERT USERS

user1 = Backend.Repo.insert!(%User{username: "johnDoe", email: "johnDoe@gmail.com", role_id: role1.id, password: Pbkdf2.hash_pwd_salt("password1")})
user2 = Backend.Repo.insert!(%User{username: "janeDoe", email: "janeDoe@gmail.com", role_id: role2.id, password: Pbkdf2.hash_pwd_salt("password2")})
user3 = Backend.Repo.insert!(%User{username: "aliceSmith", email: "aliceSmith@gmail.com", role_id: role3.id, password: Pbkdf2.hash_pwd_salt("password3")})

# INSERT WORKING TIME RECORDS

startTime1 = NaiveDateTime.from_iso8601!("2024-10-14T12:20:00")
endTime1 = NaiveDateTime.from_iso8601!("2024-10-14T20:13:00")
Backend.Repo.insert!(%Workingtime{start: startTime1, end: endTime1, user_id: user1.id})

startTime2 = NaiveDateTime.from_iso8601!("2024-10-15T08:20:00")
endTime2 = NaiveDateTime.from_iso8601!("2024-10-15T17:40:00")
Backend.Repo.insert!(%Workingtime{start: startTime2, end: endTime2, user_id: user1.id})

startTime2 = NaiveDateTime.from_iso8601!("2024-10-07T09:00:00")
endTime2 = NaiveDateTime.from_iso8601!("2024-10-07T17:00:00")
Backend.Repo.insert!(%Workingtime{start: startTime2, end: endTime2, user_id: user2.id})

startTime3 = NaiveDateTime.from_iso8601!("2024-10-08T08:30:00")
endTime3 = NaiveDateTime.from_iso8601!("2024-10-08T16:30:00")
Backend.Repo.insert!(%Workingtime{start: startTime3, end: endTime3, user_id: user3.id})

# INSERT CLOCK TIMES

time1 = NaiveDateTime.from_iso8601!("2024-10-05T12:20:00")
Backend.Repo.insert!(%Clock{status: true, time: time1, user_id: user1.id})

time2 = NaiveDateTime.from_iso8601!("2024-10-05T14:20:00")
Backend.Repo.insert!(%Clock{status: false, time: time2, user_id: user1.id})

time3 = NaiveDateTime.from_iso8601!("2024-10-06T10:20:00")
Backend.Repo.insert!(%Clock{status: true, time: time3, user_id: user1.id})

time4 = NaiveDateTime.from_iso8601!("2024-10-06T20:20:00")
Backend.Repo.insert!(%Clock{status: false, time: time4, user_id: user1.id})

time5 = NaiveDateTime.from_iso8601!("2024-10-07T09:00:00")
Backend.Repo.insert!(%Clock{status: true, time: time5, user_id: user2.id})

time6 = NaiveDateTime.from_iso8601!("2024-10-07T15:00:00")
Backend.Repo.insert!(%Clock{status: false, time: time6, user_id: user2.id})

time7 = NaiveDateTime.from_iso8601!("2024-10-08T08:30:00")
Backend.Repo.insert!(%Clock{status: true, time: time7, user_id: user3.id})

time8 = NaiveDateTime.from_iso8601!("2024-10-08T15:30:00")
Backend.Repo.insert!(%Clock{status: true, time: time8, user_id: user3.id})
