defmodule NydusOperator.Controller.V1.ExternalTest do
  @moduledoc false
  use ExUnit.Case, async: false
  alias NydusOperator.Controller.V1.External

  describe "add/1" do
    test "returns :ok" do
      event = %{}
      result = External.add(event)
      assert result == :ok
    end
  end

  describe "modify/1" do
    test "returns :ok" do
      event = %{}
      result = External.modify(event)
      assert result == :ok
    end
  end

  describe "delete/1" do
    test "returns :ok" do
      event = %{}
      result = External.delete(event)
      assert result == :ok
    end
  end

  describe "reconcile/1" do
    test "returns :ok" do
      event = %{}
      result = External.reconcile(event)
      assert result == :ok
    end
  end
end
