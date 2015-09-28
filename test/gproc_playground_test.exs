defmodule GprocPlaygroundTest do
  use ExUnit.Case

  test "registering stringly-named processes with gproc and looking them up" do
    pid = spawn(fn ->
      :gproc.reg({:n, :l, {:foo, 1}})
      :timer.sleep(:infinity)
    end)
    :timer.sleep 10
    assert ^pid = :gproc.lookup_local_name({:foo, 1})
    Process.exit(pid, :kill)
  end

  test "registering properties on a process and looking them up" do
    pid = spawn(fn ->
      :gproc.reg({:p, :l, :user}, 1)
      :timer.sleep(:infinity)
    end)
    :timer.sleep 10
    gproc_key = {:p, :l, :user}
    match_head = {gproc_key, :'$1', 1}
    guard = []
    result = [:'$1']
    query = [{match_head, guard, result}]
    assert [^pid] = :gproc.select(query)
    Process.exit(pid, :kill)
  end

  test "registering properties on 2 processes and looking them up" do
    pid1 = spawn(fn ->
      :gproc.reg({:p, :l, :user}, 1)
      :timer.sleep(:infinity)
    end)
    pid2 = spawn(fn ->
      :gproc.reg({:p, :l, :user}, 1)
      :timer.sleep(:infinity)
    end)
    :timer.sleep 10
    gproc_key = {:p, :l, :user}
    match_head = {gproc_key, :'$1', 1}
    guard = []
    result = [:'$1']
    query = [{match_head, guard, result}]
    assert [^pid1, ^pid2] = :gproc.select(query)
    Process.exit(pid1, :kill)
    Process.exit(pid2, :kill)
  end
end
