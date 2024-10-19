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

# Module to generate working times and clock times
defmodule SeedData do
  def generate_working_times_and_clocks(user, start_date, end_date) do
    Enum.each(Date.range(start_date, end_date), fn date ->
      if Date.day_of_week(date) in 1..5 do
        start_hour = Enum.random(7..9)
        start_minute = Enum.random(0..59)
        end_hour = start_hour + Enum.random(6..9)
        end_minute = Enum.random(0..59)

        start_time = NaiveDateTime.new!(date, Time.new!(start_hour, start_minute, 0))
        end_time = NaiveDateTime.new!(date, Time.new!(end_hour, end_minute, 0))
        Backend.Repo.insert!(%Workingtime{start: start_time, end: end_time, user_id: user.id})

        clock_in_time = NaiveDateTime.new!(date, Time.new!(start_hour, start_minute, 0))
        clock_out_time = NaiveDateTime.new!(date, Time.new!(end_hour, end_minute, 0))
        Backend.Repo.insert!(%Clock{status: true, time: clock_in_time, user_id: user.id})
        Backend.Repo.insert!(%Clock{status: false, time: clock_out_time, user_id: user.id})
      end
    end)
  end
end

# Generate data for September, October, and November 2024
SeedData.generate_working_times_and_clocks(user1, ~D[2024-09-01], ~D[2024-11-30])
SeedData.generate_working_times_and_clocks(user2, ~D[2024-09-01], ~D[2024-11-30])
SeedData.generate_working_times_and_clocks(user3, ~D[2024-09-01], ~D[2024-11-30])
