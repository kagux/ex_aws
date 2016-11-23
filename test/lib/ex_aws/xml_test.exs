defmodule ExAws.XmlTest do
  use ExUnit.Case, async: true
  alias ExAws.Xml

  test "it adds optional node" do
    nodes = [:node] |> Xml.add_optional_node(
     {:new_node, %{foo: :bar}, [:child])
    assert [{:new_node, %{foo: :bar}, [:child]}, :node] == nodes
  end

  test "it does not add optional node when childrenl have nil values" do
    nodes = [:node] |> Xml.add_optional_node(:new_node, %{foo: :bar}, [:child])

  end
end
