defmodule ExAws.Route53 do
  @moduledoc """
  Operations on AWS Route53
  """

  @type list_hosted_zones_opts :: [
    {:marker, binary} |
    {:max_items, 1..100}
  ]
  @doc "List hosted zones"
  @spec list_hosted_zones(opts :: list_hosted_zones_opts) :: ExAws.Operation.RestQuery.t
  def list_hosted_zones(opts \\ []) do
    opts = opts
            |> Map.new
            |> Map.put(:maxitems, opts[:max_items])
            |> Map.delete(:max_items)
            |> Enum.reject(fn {_, v} -> is_nil(v) end)
            |> Enum.into(%{})
    request(:get, :list_hosted_zones, params: opts)
  end

  def create_hosted_zone(opts \\ []) do
    payload = """
      <?xml version="1.0" encoding="UTF-8"?>
        <CreateHostedZoneRequest xmlns="https://route53.amazonaws.com/doc/2013-04-01/">
           <CallerReference>tmp</CallerReference>
           <Name>example.com</Name>
        </CreateHostedZoneRequest>
      """
    payload =
    {:CreateHostedZoneRequest, %{xmlns: "https://route53.amazonaws.com/doc/2013-04-01/"}, [
      {:CallerReference, nil, "tmp"},
      {:Name, nil, "example.com"},
    ]} |> XmlBuilder.doc
    request(:post, :create_hosted_zone, body: payload)
  end

  ## Request
  ######################

  defp request(http_method, action, opts) do
    %ExAws.Operation.RestQuery{
      http_method: http_method,
      path: "/2013-04-01/hostedzone",
      params: Keyword.get(opts, :params, %{}),
      body: Keyword.get(opts, :body, ""),
      service: :route53,
      action: action,
      parser: &ExAws.Route53.Parsers.parse/2
    }
  end
end
