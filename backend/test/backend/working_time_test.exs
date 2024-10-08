defmodule Backend.WorkingTimeTest do
  use Backend.DataCase

  alias Backend.WorkingTime

  describe "workingtime" do
    alias Backend.WorkingTime.Workingtime

    import Backend.WorkingTimeFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/0 returns all workingtime" do
      workingtime = workingtime_fixture()
      assert WorkingTime.list_workingtime() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert WorkingTime.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{start: "2024-10-06 12:13:00", end: "2024-10-06 12:13:00", user_id: workingtime_fixture().user_id}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.create_workingtime(valid_attrs)
      assert workingtime.start == "2024-10-06 12:13:00"
      assert workingtime.end == "2024-10-06 12:13:00"
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{start: "2024-10-07 12:13:00", end: "2024-10-07 12:13:00"}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.update_workingtime(workingtime, update_attrs)
      assert workingtime.start == "2024-10-07 12:13:00"
      assert workingtime.end == "2024-10-07 12:13:00"
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == WorkingTime.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = WorkingTime.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_workingtime(workingtime)
    end
  end
end
