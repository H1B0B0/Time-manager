defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "users" do
    alias Backend.Accounts.User

    import Backend.AccountsFixtures

    @create_attrs %{
      username: "Jake Doe",
      email: "jake.doe@mail.com",
      password: "password"
    }
    @update_attrs %{
      username: "Jana Doe",
      email: "jana.doe@mail.zz",
      password: "passwooord"
    }
    @invalid_attrs %{username: nil, email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      role = role_fixture()
      valid_attrs = %{username: @create_attrs.username, email: @create_attrs.email, password: @create_attrs.password, role_id: role.id}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == "Jake Doe"
      assert user.email == "jake.doe@mail.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: @update_attrs.username, email: @update_attrs.email}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.username == "Jana Doe"
      assert user.email == "jana.doe@mail.zz"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "roles" do
    alias Backend.Accounts.Role

    import Backend.AccountsFixtures

    @invalid_attrs %{category: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end
  end
end
