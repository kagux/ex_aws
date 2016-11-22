defmodule ExAws.Route53.Payload.CreateHostedZone do
  def build(opts) do
    {
      :CreateHostedZoneRequest,
      %{xmlns: "https://route53.amazonaws.com/doc/2013-04-01/"},
      request_children(opts)
    }
    |> XmlBuilder.doc
  end

  defp request_children(opts) do
    [
      {:CallerReference, nil, uuid},
      {:Name, nil, opts[:name]},
    ]
    |> add_hosted_zone_config(opts)
    |> add_vps(opts)
  end

  defp add_vps(children, opts) do
    case vpc(opts) do
      [] -> children
      vpc -> [{:VPC, nil, vpc} | children]
    end
  end

  defp vpc(%{vpc_id: vpc_id, vpc_region: vpc_region}) do
    [
      {:VPCId, nil, vpc_id},
      {:VPCRegion, nil, vpc_region}
    ] 
  end
  defp vpc(_), do: []

  defp add_hosted_zone_config(children, opts) do
    case hosted_zone_config(opts) do
      [] -> children
      config -> [{:HostedZoneConfig, nil, config} | children]
    end
  end

  defp hosted_zone_config(%{comment: comment} = opts) do
    children = opts |> Map.delete(:comment) |> hosted_zone_config
    [{:Comment, nil, comment} | children]
  end
  defp hosted_zone_config(%{private: private} = opts) do
    children = opts |> Map.delete(:private) |> hosted_zone_config
    [{:PrivateZone, nil, private} | children]
  end
  defp hosted_zone_config(_), do: []

  defp uuid, do: DateTime.utc_now |> :erlang.phash2
end
