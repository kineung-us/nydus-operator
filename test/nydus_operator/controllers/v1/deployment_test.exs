defmodule NydusOperator.Controller.V1.DeploymentTest do
  @moduledoc false
  use ExUnit.Case, async: false
  alias NydusOperator.Controller.V1.Deployment

  describe "add/1" do
    test "returns :ok" do
      event = %{}
      result = Deployment.add(event)
      assert result == :ok
    end
  end

  describe "modify/1" do
    test "returns :ok" do
      event = %{}
      result = Deployment.modify(event)
      assert result == :ok
    end
  end

  describe "delete/1" do
    test "returns :ok" do
      event = %{}
      result = Deployment.delete(event)
      assert result == :ok
    end
  end

  describe "reconcile/1" do
    test "returns :ok" do
      event = %{}
      result = Deployment.reconcile(event)
      assert result == :ok
    end
  end
end
