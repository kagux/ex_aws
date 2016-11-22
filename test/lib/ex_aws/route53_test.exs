defmodule ExAws.Route53Test do
  use ExUnit.Case, async: true
  alias ExAws.Route53
  alias ExAws.Operation.RestQuery

  test "list hosted zones" do
    expected = %RestQuery{
      service: :route53,
      path: "/2013-04-01/hostedzone",
      action: :list_hosted_zones,
      http_method: :get,
      params: %{},
      body: "",
      parser: &ExAws.Route53.Parsers.parse/2
    }
    assert expected == Route53.list_hosted_zones
  end

  test "list hosted zones with options" do
    request = %RestQuery{} = Route53.list_hosted_zones marker: "marker", max_items: 10
    assert Map.get(request, :params) == %{ marker: "marker", maxitems: 10 }
  end

  test "create hosted zone" do
    expected_response = %{
      service: :route53,
      path: "/2013-04-01/hostedzone",
      action: :create_hosted_zone,
      http_method: :post,
      params: %{},
      parser: &ExAws.Route53.Parsers.parse/2
    }

    response = Route53.create_hosted_zone name: "example.com"
    assert %RestQuery{} = response
    assert expected_response == Map.take(response, [:service, :path, :action, :http_method, :params, :parser])

    expected_body = ~r"""
      <?xml version="1.0" encoding="UTF-8" \?>
      <CreateHostedZoneRequest xmlns="https://route53.amazonaws.com/doc/2013-04-01/">
      	<CallerReference>.*?</CallerReference>
      	<Name>example.com</Name>
      </CreateHostedZoneRequest>\
      """
    assert Regex.match?(expected_body, response.body)
  end
end
