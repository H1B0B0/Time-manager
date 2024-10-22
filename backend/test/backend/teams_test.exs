defmodule Backend.TeamsTest do
  use Backend.DataCase

  alias Backend.Teams

  describe "teams" do
    alias Backend.Teams.Team

    import Backend.TeamsFixtures

    @invalid_attrs %{name: nil, owner_id: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      user = Backend.AccountsFixtures.user_fixture()
      valid_attrs = %{name: "some name", owner_id: user.id}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "some name"
      assert team.owner_id == user.id
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name", owner_id: team.owner_id}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "some updated name"
      assert team.owner_id == team.owner_id
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  describe "teams_users" do
    alias Backend.Teams.TeamUser

    import Backend.TeamsFixtures

    @invalid_attrs %{}

    test "list_teams_users/0 returns all teams_users" do
      team_user = team_user_fixture()
      assert Teams.list_teams_users() == [team_user]
    end

    test "get_team_user!/1 returns the team_user with given id" do
      team_user = team_user_fixture()
      assert Teams.get_team_user!(team_user.id) == team_user
    end

    test "create_team_user/1 with valid data creates a team_user" do
      valid_attrs = %{}

      assert {:ok, %TeamUser{} = team_user} = Teams.create_team_user(valid_attrs)
    end

    test "create_team_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team_user(@invalid_attrs)
    end

    test "update_team_user/2 with valid data updates the team_user" do
      team_user = team_user_fixture()
      update_attrs = %{}

      assert {:ok, %TeamUser{} = team_user} = Teams.update_team_user(team_user, update_attrs)
    end

    test "update_team_user/2 with invalid data returns error changeset" do
      team_user = team_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team_user(team_user, @invalid_attrs)
      assert team_user == Teams.get_team_user!(team_user.id)
    end

    test "delete_team_user/1 deletes the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{}} = Teams.delete_team_user(team_user)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_user!(team_user.id) end
    end

    test "change_team_user/1 returns a team_user changeset" do
      team_user = team_user_fixture()
      assert %Ecto.Changeset{} = Teams.change_team_user(team_user)
    end
  end
end
