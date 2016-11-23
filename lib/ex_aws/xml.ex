defmodule ExAws.Xml do
  def add_optional_node(nodes, name, attrs, content) do
    [{name, attrs, content} | nodes]
  end
end
