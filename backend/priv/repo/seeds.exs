# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Backend.Accounts.User
alias Backend.WorkingTime.Workingtime
alias Backend.Time.Clock

# USERS

Backend.Repo.delete_all(User)
Backend.Repo.query("ALTER SEQUENCE users_id_seq RESTART")

user1 = Backend.Repo.insert!(%User{username: "johnDoe", email: "johnDoe@gmail.com"})
user2 = Backend.Repo.insert!(%User{username: "janeDoe", email: "janeDoe@gmail.com"})
user3 = Backend.Repo.insert!(%User{username: "aliceSmith", email: "aliceSmith@gmail.com"})

# WORKINGTIME

Backend.Repo.delete_all(Workingtime)
Backend.Repo.query("ALTER SEQUENCE workingtime_id_seq RESTART")

startTime1 = NaiveDateTime.from_iso8601!("2024-10-05T12:20:00")
endTime1 = NaiveDateTime.from_iso8601!("2024-10-06T20:13:00")
Backend.Repo.insert!(%Workingtime{start: startTime1, end: endTime1, user_id: user1.id})

startTime2 = NaiveDateTime.from_iso8601!("2024-10-07T09:00:00")
endTime2 = NaiveDateTime.from_iso8601!("2024-10-07T17:00:00")
Backend.Repo.insert!(%Workingtime{start: startTime2, end: endTime2, user_id: user2.id})

startTime3 = NaiveDateTime.from_iso8601!("2024-10-08T08:30:00")
endTime3 = NaiveDateTime.from_iso8601!("2024-10-08T16:30:00")
Backend.Repo.insert!(%Workingtime{start: startTime3, end: endTime3, user_id: user3.id})

# CLOCK

Backend.Repo.delete_all(Clock)
Backend.Repo.query("ALTER SEQUENCE clocks_id_seq RESTART")

time1 = NaiveDateTime.from_iso8601!("2024-10-05T12:20:00")
Backend.Repo.insert!(%Clock{status: true, time: time1, user_id: user1.id})

time2 = NaiveDateTime.from_iso8601!("2024-10-07T09:00:00")
Backend.Repo.insert!(%Clock{status: true, time: time2, user_id: user2.id})

time3 = NaiveDateTime.from_iso8601!("2024-10-08T08:30:00")
Backend.Repo.insert!(%Clock{status: true, time: time3, user_id: user3.id})
