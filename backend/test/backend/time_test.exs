defmodule Backend.TimeTest do
  use Backend.DataCase

  alias Backend.Time
  alias Backend.Accounts
  alias Backend.Accounts.User

  describe "clocks" do
    alias Backend.Time.Clock

    import Backend.TimeFixtures

    @invalid_attrs %{status: nil, time: nil, user_id: nil}

    setup do
      unique_id = System.unique_integer([:positive])
      email = "test#{unique_id}@example.com"
      role = Backend.AccountsFixtures.role_fixture()
      {:ok, user} = Accounts.create_user(%{username: "testuser#{unique_id}", name: "Test User", email: email, password: "password", role_id: role.id})
      %{user: user}
    end

    test "create_clock/1 with valid data creates a clock", %{user: user} do
      valid_attrs = %{status: true, time: ~N[2024-10-06 12:11:00], user_id: user.id}

      assert {:ok, %Clock{} = clock} = Time.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-06 12:11:00]
      assert clock.user_id == user.id
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_clock(@invalid_attrs)
    end

    test "list_user_clocks/1 returns all clocks for a user", %{user: user} do
      clock = clock_fixture(%{user_id: user.id})
      assert Time.list_user_clocks(user.id) == [clock]
    end
  end
end
