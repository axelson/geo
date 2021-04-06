defmodule Geo.WKB.Test do
  use ExUnit.Case, async: true
  use ExUnitProperties

  test "Decode WKB to Point" do
    point = Geo.WKB.decode!("0101000000000000000000F03F000000000000F03F")
    assert(point.coordinates == {1, 1})
  end

  test "Decode WKB to Point with zeros" do
    point = Geo.WKB.decode!("010100000000000000000000000000000000000000")
    assert(point.coordinates == {0, 0})
  end

  test "Decode WKB to PointM" do
    point = Geo.WKB.decode!("0101000040000000000000F03F000000000000F03F000000000000F03F")
    assert(point.coordinates == {1, 1, 1})
  end

  test "Decode WKB to PointZ" do
    point = Geo.WKB.decode!("0101000080000000000000F03F000000000000F03F000000000000F03F")
    assert(point.coordinates == {1, 1, 1})
  end

  test "Decode WKB to PointZM" do
    point =
      Geo.WKB.decode!(
        "01010000C0000000000000F03F000000000000F03F000000000000F03F000000000000F03F"
      )

    assert(point.coordinates == {1, 1, 1, 1})
  end

  test "Decode EWKB to Point" do
    point = Geo.WKB.decode!("0101000020E61000009EFB613A637B4240CF2C0950D3735EC0")
    assert(point.coordinates == {36.9639657, -121.8097725})
    assert(point.srid == 4326)
  end

  test "Encode Point to WKB" do
    geom = %Geo.Point{coordinates: {1, 1}}
    assert(Geo.WKB.encode!(geom, :ndr) == "0101000000000000000000F03F000000000000F03F")
  end

  test "Encode Points with zeros to WKB" do
    assert(
      Geo.WKB.encode!(%Geo.Point{coordinates: {0, 0}}, :ndr) ==
        "010100000000000000000000000000000000000000"
    )

    assert(
      Geo.WKB.encode!(%Geo.Point{coordinates: {1, 0}}, :ndr) ==
        "0101000000000000000000F03F0000000000000000"
    )

    assert(
      Geo.WKB.encode!(%Geo.Point{coordinates: {0, 1}}, :ndr) ==
        "01010000000000000000000000000000000000F03F"
    )
  end

  test "Encode PointM to WKB" do
    geom = %Geo.PointM{coordinates: {1, 1, 1}}

    assert(
      Geo.WKB.encode!(geom, :ndr) == "0101000040000000000000F03F000000000000F03F000000000000F03F"
    )
  end

  test "Encode PointZ to WKB" do
    geom = %Geo.PointZ{coordinates: {1, 1, 1}}

    assert(
      Geo.WKB.encode!(geom, :ndr) == "0101000080000000000000F03F000000000000F03F000000000000F03F"
    )
  end

  test "Encode PointZs with zeros to WKB" do
    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {0, 0, 0}}, :ndr) ==
        "0101000080000000000000000000000000000000000000000000000000"
    )

    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {0, 1, 0}}, :ndr) ==
        "01010000800000000000000000000000000000F03F0000000000000000"
    )

    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {0, 0, 1}}, :ndr) ==
        "010100008000000000000000000000000000000000000000000000F03F"
    )

    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {1, 0, 1}}, :ndr) ==
        "0101000080000000000000F03F0000000000000000000000000000F03F"
    )

    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {1, 0, 0}}, :ndr) ==
        "0101000080000000000000F03F00000000000000000000000000000000"
    )

    assert(
      Geo.WKB.encode!(%Geo.PointZ{coordinates: {0, 1, 1}}, :ndr) ==
        "01010000800000000000000000000000000000F03F000000000000F03F"
    )
  end

  test "Encode PointZM to WKB" do
    geom = %Geo.PointZM{coordinates: {1, 1, 1, 1}}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01010000C0000000000000F03F000000000000F03F000000000000F03F000000000000F03F"
    )
  end

  test "Encode Point to EWKB" do
    geom = %Geo.Point{coordinates: {36.9639657, -121.8097725}, srid: 4326}
    assert(Geo.WKB.encode!(geom, :ndr) == "0101000020E61000009EFB613A637B4240CF2C0950D3735EC0")
  end

  test "Decode WKB to Line String" do
    point =
      Geo.WKB.decode!(
        "0102000000030000000000000000003E40000000000000244000000000000024400000000000003E4000000000000044400000000000004440"
      )

    assert(point.coordinates == [{30, 10}, {10, 30}, {40, 40}])
  end

  test "Decode EWKB to Line String" do
    point =
      Geo.WKB.decode!(
        "0102000020E6100000030000000000000000003E40000000000000244000000000000024400000000000003E4000000000000044400000000000004440"
      )

    assert(point.coordinates == [{30, 10}, {10, 30}, {40, 40}])
    assert(point.srid == 4326)
  end

  test "Encode Line String to WKB" do
    geom = %Geo.LineString{coordinates: [{30, 10}, {10, 30}, {40, 40}]}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0102000000030000000000000000003E40000000000000244000000000000024400000000000003E4000000000000044400000000000004440"
    )
  end

  test "Encode Line String to EWKB" do
    geom = %Geo.LineString{coordinates: [{30, 10}, {10, 30}, {40, 40}], srid: 4326}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0102000020E6100000030000000000000000003E40000000000000244000000000000024400000000000003E4000000000000044400000000000004440"
    )
  end

  test "Decode WKB to LineStringZ" do
    point =
      Geo.WKB.decode!(
        "008000000200000003403E000000000000402400000000000040080000000000004024000000000000403E0000000000004056800000000000404400000000000040440000000000004044000000000000"
      )

    assert(point.coordinates == [{30, 10, 3}, {10, 30, 90}, {40, 40, 40}])
  end

  test "Decode EWKB to LineStringZ" do
    point =
      Geo.WKB.decode!(
        "00A0000002000010E600000003403E000000000000402400000000000040080000000000004024000000000000403E0000000000004056800000000000404400000000000040440000000000004044000000000000"
      )

    assert(point.coordinates == [{30, 10, 3}, {10, 30, 90}, {40, 40, 40}])
    assert(point.srid == 4326)
  end

  test "Encode LineStringZ to WKB" do
    geom = %Geo.LineStringZ{coordinates: [{30, 10, 3}, {10, 30, 90}, {40, 40, 40}]}

    assert(
      Geo.WKB.encode!(geom) ==
        "008000000200000003403E000000000000402400000000000040080000000000004024000000000000403E0000000000004056800000000000404400000000000040440000000000004044000000000000"
    )
  end

  test "Encode LineStringZ to EWKB" do
    geom = %Geo.LineStringZ{coordinates: [{30, 10, 3}, {10, 30, 90}, {40, 40, 40}], srid: 4326}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01020000A0E6100000030000000000000000003E400000000000002440000000000000084000000000000024400000000000003E400000000000805640000000000000444000000000000044400000000000004440"
    )
  end

  test "Decode WKB to Polygon" do
    point =
      Geo.WKB.decode!(
        "0103000000020000000500000000000000008041400000000000002440000000000080464000000000008046400000000000002E40000000000000444000000000000024400000000000003440000000000080414000000000000024400400000000000000000034400000000000003E40000000000080414000000000008041400000000000003E40000000000000344000000000000034400000000000003E40"
      )

    assert(
      point.coordinates == [
        [{35, 10}, {45, 45}, {15, 40}, {10, 20}, {35, 10}],
        [{20, 30}, {35, 35}, {30, 20}, {20, 30}]
      ]
    )
  end

  test "Decode EWKB to Polygon" do
    point =
      Geo.WKB.decode!(
        "0103000020E6100000020000000500000000000000008041400000000000002440000000000080464000000000008046400000000000002E40000000000000444000000000000024400000000000003440000000000080414000000000000024400400000000000000000034400000000000003E40000000000080414000000000008041400000000000003E40000000000000344000000000000034400000000000003E40"
      )

    assert(
      point.coordinates == [
        [{35, 10}, {45, 45}, {15, 40}, {10, 20}, {35, 10}],
        [{20, 30}, {35, 35}, {30, 20}, {20, 30}]
      ]
    )

    assert(point.srid == 4326)
  end

  test "Encode Polygon to WKB" do
    geom = %Geo.Polygon{
      coordinates: [
        [{35, 10}, {45, 45}, {15, 40}, {10, 20}, {35, 10}],
        [{20, 30}, {35, 35}, {30, 20}, {20, 30}]
      ]
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0103000000020000000500000000000000008041400000000000002440000000000080464000000000008046400000000000002E40000000000000444000000000000024400000000000003440000000000080414000000000000024400400000000000000000034400000000000003E40000000000080414000000000008041400000000000003E40000000000000344000000000000034400000000000003E40"
    )
  end

  test "Encode Polygon to EWKB" do
    geom = %Geo.Polygon{
      coordinates: [
        [{35, 10}, {45, 45}, {15, 40}, {10, 20}, {35, 10}],
        [{20, 30}, {35, 35}, {30, 20}, {20, 30}]
      ],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0103000020E6100000020000000500000000000000008041400000000000002440000000000080464000000000008046400000000000002E40000000000000444000000000000024400000000000003440000000000080414000000000000024400400000000000000000034400000000000003E40000000000080414000000000008041400000000000003E40000000000000344000000000000034400000000000003E40"
    )
  end

  test "Decode PolygonZ from WKB" do
    geom =
      Geo.WKB.decode!(
        "010300008002000000050000000000000000804140000000000000244000000000000024400000000000804640000000000080464000000000000000000000000000002E4000000000000044400000000000003E400000000000002440000000000000344000000000000034400000000000804140000000000000244000000000000024400400000000000000000034400000000000003E4000000000000044400000000000804140000000000080414000000000008041400000000000003E400000000000003440000000000000244000000000000034400000000000003E400000000000004440"
      )

    assert(
      geom.coordinates ==
        [
          [{35, 10, 10}, {45, 45, 0}, {15, 40, 30}, {10, 20, 20}, {35, 10, 10}],
          [{20, 30, 40}, {35, 35, 35}, {30, 20, 10}, {20, 30, 40}]
        ]
    )
  end

  test "Encode PolygonZ to WKB" do
    geom = %Geo.PolygonZ{
      coordinates: [
        [{35, 10, 10}, {45, 45, 0}, {15, 40, 30}, {10, 20, 20}, {35, 10, 10}],
        [{20, 30, 40}, {35, 35, 35}, {30, 20, 10}, {20, 30, 40}]
      ]
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "010300008002000000050000000000000000804140000000000000244000000000000024400000000000804640000000000080464000000000000000000000000000002E4000000000000044400000000000003E400000000000002440000000000000344000000000000034400000000000804140000000000000244000000000000024400400000000000000000034400000000000003E4000000000000044400000000000804140000000000080414000000000008041400000000000003E400000000000003440000000000000244000000000000034400000000000003E400000000000004440"
    )
  end

  test "Decode PolygonZ from EWKB" do
    geom =
      Geo.WKB.decode!(
        "01030000A0E610000002000000050000000000000000804140000000000000244000000000000024400000000000804640000000000080464000000000000000000000000000002E4000000000000044400000000000003E400000000000002440000000000000344000000000000034400000000000804140000000000000244000000000000024400400000000000000000034400000000000003E4000000000000044400000000000804140000000000080414000000000008041400000000000003E400000000000003440000000000000244000000000000034400000000000003E400000000000004440"
      )

    assert(
      geom.coordinates ==
        [
          [{35, 10, 10}, {45, 45, 0}, {15, 40, 30}, {10, 20, 20}, {35, 10, 10}],
          [{20, 30, 40}, {35, 35, 35}, {30, 20, 10}, {20, 30, 40}]
        ]
    )

    assert(geom.srid == 4326)
  end

  test "Encode PolygonZ to EWKB" do
    geom = %Geo.PolygonZ{
      coordinates: [
        [{35, 10, 10}, {45, 45, 0}, {15, 40, 30}, {10, 20, 20}, {35, 10, 10}],
        [{20, 30, 40}, {35, 35, 35}, {30, 20, 10}, {20, 30, 40}]
      ],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01030000A0E610000002000000050000000000000000804140000000000000244000000000000024400000000000804640000000000080464000000000000000000000000000002E4000000000000044400000000000003E400000000000002440000000000000344000000000000034400000000000804140000000000000244000000000000024400400000000000000000034400000000000003E4000000000000044400000000000804140000000000080414000000000008041400000000000003E400000000000003440000000000000244000000000000034400000000000003E400000000000004440"
    )
  end

  test "Decode WKB to MultiPoint" do
    point =
      Geo.WKB.decode!(
        "01040000000300000001010000000000000000000000000000000000000001010000000000000000003440000000000000344001010000000000000000004E400000000000004E40"
      )

    assert(point.coordinates == [{0, 0}, {20, 20}, {60, 60}])
  end

  test "Decode EWKB to MultiPoint" do
    point =
      Geo.WKB.decode!(
        "0104000020E61000000300000001010000000000000000000000000000000000000001010000000000000000003440000000000000344001010000000000000000004E400000000000004E40"
      )

    assert(point.coordinates == [{0, 0}, {20, 20}, {60, 60}])
    assert(point.srid == 4326)
  end

  test "Encode MultiPoint to WKB" do
    geom = %Geo.MultiPoint{coordinates: [{0, 0}, {20, 20}, {60, 60}]}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01040000000300000001010000000000000000000000000000000000000001010000000000000000003440000000000000344001010000000000000000004E400000000000004E40"
    )
  end

  test "Encode MultiPoint to EWKB" do
    geom = %Geo.MultiPoint{coordinates: [{0, 0}, {20, 20}, {60, 60}], srid: 4326}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0104000020E61000000300000001010000000000000000000000000000000000000001010000000000000000003440000000000000344001010000000000000000004E400000000000004E40"
    )
  end

  test "Decode WKB to MultiPointZ" do
    point =
      Geo.WKB.decode!(
        "0104000080030000000101000080000000000000000000000000000000000000000000000000010100008000000000000034400000000000003440000000000000344001010000800000000000004E400000000000004E400000000000004E40"
      )

    assert(point.coordinates == [{0, 0, 0}, {20, 20, 20}, {60, 60, 60}])
  end

  test "Decode EWKB to MultiPointZ" do
    point =
      Geo.WKB.decode!(
        "01040000A0E6100000030000000101000080000000000000000000000000000000000000000000000000010100008000000000000034400000000000003440000000000000344001010000800000000000004E400000000000004E400000000000004E40"
      )

    assert(point.coordinates == [{0, 0, 0}, {20, 20, 20}, {60, 60, 60}])
    assert(point.srid == 4326)
  end

  test "Encode MultiPointZ to WKB" do
    geom = %Geo.MultiPointZ{coordinates: [{0, 0, 0}, {20, 20, 20}, {60, 60, 60}]}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0104000080030000000101000080000000000000000000000000000000000000000000000000010100008000000000000034400000000000003440000000000000344001010000800000000000004E400000000000004E400000000000004E40"
    )
  end

  test "Encode MultiPointZ to EWKB" do
    geom = %Geo.MultiPointZ{coordinates: [{0, 0, 0}, {20, 20, 20}, {60, 60, 60}], srid: 4326}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01040000A0E6100000030000000101000080000000000000000000000000000000000000000000000000010100008000000000000034400000000000003440000000000000344001010000800000000000004E400000000000004E400000000000004E40"
    )
  end

  test "Decode EWKB to MultiLineString" do
    point =
      Geo.WKB.decode!(
        "0020000005000010E6000000020000000002000000024024000000000000402400000000000040340000000000004034000000000000000000000200000002402E000000000000402E000000000000403E000000000000402E000000000000"
      )

    assert(point.coordinates == [[{10, 10}, {20, 20}], [{15, 15}, {30, 15}]])
    assert(point.srid == 4326)
  end

  test "Encode MultiLineString to WKB" do
    geom = %Geo.MultiLineString{coordinates: [[{10, 10}, {20, 20}], [{15, 15}, {30, 15}]]}

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01050000000200000001020000000200000000000000000024400000000000002440000000000000344000000000000034400102000000020000000000000000002E400000000000002E400000000000003E400000000000002E40"
    )
  end

  test "Decode WKB to MultiLineStringZ" do
    geom =
      Geo.WKB.decode!(
        "00A0000005000010E600000002008000000200000002402400000000000040240000000000004024000000000000403400000000000040340000000000004034000000000000008000000200000002402E000000000000402E000000000000402E000000000000403E000000000000402E0000000000004024000000000000"
      )

    expected_coords = [[{10, 10, 10}, {20, 20, 20}], [{15, 15, 15}, {30, 15, 10}]]

    assert(geom.coordinates == expected_coords)
  end

  test "Encode MultiLineStringZ to WKB" do
    geom = %Geo.MultiLineStringZ{
      coordinates: [[{10, 10, 10}, {20, 20, 20}], [{15, 15, 15}, {30, 15, 10}]]
    }

    assert(
      Geo.WKB.encode!(geom) ==
        "008000000500000002008000000200000002402400000000000040240000000000004024000000000000403400000000000040340000000000004034000000000000008000000200000002402E000000000000402E000000000000402E000000000000403E000000000000402E0000000000004024000000000000"
    )
  end

  test "Decode EWKB to MultiLineStringZ" do
    geom =
      Geo.WKB.decode!(
        "01050000A0E6100000020000000102000080020000000000000000002440000000000000244000000000000024400000000000003440000000000000344000000000000034400102000080020000000000000000002E400000000000002E400000000000002E400000000000003E400000000000002E400000000000002440"
      )

    expected_coords = [[{10, 10, 10}, {20, 20, 20}], [{15, 15, 15}, {30, 15, 10}]]

    assert(geom.coordinates == expected_coords)
    assert(geom.srid == 4326)
  end

  test "Encode MultiLineStringZ to EWKB" do
    geom = %Geo.MultiLineStringZ{
      coordinates: [[{10, 10, 10}, {20, 20, 20}], [{15, 15, 15}, {30, 15, 10}]],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01050000A0E6100000020000000102000080020000000000000000002440000000000000244000000000000024400000000000003440000000000000344000000000000034400102000080020000000000000000002E400000000000002E400000000000002E400000000000003E400000000000002E400000000000002440"
    )
  end

  test "Encode MultiLineString to EWKB" do
    geom = %Geo.MultiLineString{
      coordinates: [[{10, 10}, {20, 20}], [{15, 15}, {30, 15}]],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0105000020E61000000200000001020000000200000000000000000024400000000000002440000000000000344000000000000034400102000000020000000000000000002E400000000000002E400000000000003E400000000000002E40"
    )
  end

  test "Decode EWKB to MultiPolygon" do
    point =
      Geo.WKB.decode!(
        "0106000020E61000000200000001030000000100000004000000000000000000444000000000000044400000000000003440000000000080464000000000008046400000000000003E4000000000000044400000000000004440010300000002000000060000000000000000003440000000000080414000000000000024400000000000003E40000000000000244000000000000024400000000000003E4000000000000014400000000000804640000000000000344000000000000034400000000000804140040000000000000000003E40000000000000344000000000000034400000000000002E40000000000000344000000000000039400000000000003E400000000000003440"
      )

    assert(
      point.coordinates == [
        [[{40, 40}, {20, 45}, {45, 30}, {40, 40}]],
        [
          [{20, 35}, {10, 30}, {10, 10}, {30, 5}, {45, 20}, {20, 35}],
          [{30, 20}, {20, 15}, {20, 25}, {30, 20}]
        ]
      ]
    )

    assert(point.srid == 4326)
  end

  test "Decode empty MultiPolygon EWKB to MultiPolygon" do
    multipolygon = Geo.WKB.decode!("0106000020E610000000000000")
    assert(multipolygon.coordinates == [])
    assert(multipolygon.srid == 4326)
  end

  test "Encode MultiPolygon to WKB" do
    geom = %Geo.MultiPolygon{
      coordinates: [
        [[{40, 40}, {20, 45}, {45, 30}, {40, 40}]],
        [
          [{20, 35}, {10, 30}, {10, 10}, {30, 5}, {45, 20}, {20, 35}],
          [{30, 20}, {20, 15}, {20, 25}, {30, 20}]
        ]
      ]
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01060000000200000001030000000100000004000000000000000000444000000000000044400000000000003440000000000080464000000000008046400000000000003E4000000000000044400000000000004440010300000002000000060000000000000000003440000000000080414000000000000024400000000000003E40000000000000244000000000000024400000000000003E4000000000000014400000000000804640000000000000344000000000000034400000000000804140040000000000000000003E40000000000000344000000000000034400000000000002E40000000000000344000000000000039400000000000003E400000000000003440"
    )
  end

  test "Encode MultiPolygon to EWKB" do
    geom = %Geo.MultiPolygon{
      coordinates: [
        [[{40, 40}, {20, 45}, {45, 30}, {40, 40}]],
        [
          [{20, 35}, {10, 30}, {10, 10}, {30, 5}, {45, 20}, {20, 35}],
          [{30, 20}, {20, 15}, {20, 25}, {30, 20}]
        ]
      ],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "0106000020E61000000200000001030000000100000004000000000000000000444000000000000044400000000000003440000000000080464000000000008046400000000000003E4000000000000044400000000000004440010300000002000000060000000000000000003440000000000080414000000000000024400000000000003E40000000000000244000000000000024400000000000003E4000000000000014400000000000804640000000000000344000000000000034400000000000804140040000000000000000003E40000000000000344000000000000034400000000000002E40000000000000344000000000000039400000000000003E400000000000003440"
    )
  end

  test "Encode MultiPolygonZ to EWKB" do
    geom = %Geo.MultiPolygonZ{
      coordinates: [
        [[{40, 40, 40}, {20, 45, 60}, {45, 30, 15}, {40, 40, 40}]],
        [
          [{20, 35, 48}, {10, 30, 50}, {10, 10, 10}, {30, 5, 18}, {45, 20, 10}, {20, 35, 48}],
          [{30, 20, 10}, {20, 15, 10}, {20, 25, 4}, {30, 20, 10}]
        ]
      ],
      srid: 4326
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01060000A0E61000000200000001030000800100000004000000000000000000444000000000000044400000000000004440000000000000344000000000008046400000000000004E4000000000008046400000000000003E400000000000002E400000000000004440000000000000444000000000000044400103000080020000000600000000000000000034400000000000804140000000000000484000000000000024400000000000003E4000000000000049400000000000002440000000000000244000000000000024400000000000003E4000000000000014400000000000003240000000000080464000000000000034400000000000002440000000000000344000000000008041400000000000004840040000000000000000003E400000000000003440000000000000244000000000000034400000000000002E4000000000000024400000000000003440000000000000394000000000000010400000000000003E4000000000000034400000000000002440"
    )
  end

  test "Encode MultiPolygonZ to WKB" do
    geom = %Geo.MultiPolygonZ{
      coordinates: [
        [[{40, 40, 40}, {20, 45, 60}, {45, 30, 15}, {40, 40, 40}]],
        [
          [{20, 35, 48}, {10, 30, 50}, {10, 10, 10}, {30, 5, 18}, {45, 20, 10}, {20, 35, 48}],
          [{30, 20, 10}, {20, 15, 10}, {20, 25, 4}, {30, 20, 10}]
        ]
      ]
    }

    assert(
      Geo.WKB.encode!(geom, :ndr) ==
        "01060000800200000001030000800100000004000000000000000000444000000000000044400000000000004440000000000000344000000000008046400000000000004E4000000000008046400000000000003E400000000000002E400000000000004440000000000000444000000000000044400103000080020000000600000000000000000034400000000000804140000000000000484000000000000024400000000000003E4000000000000049400000000000002440000000000000244000000000000024400000000000003E4000000000000014400000000000003240000000000080464000000000000034400000000000002440000000000000344000000000008041400000000000004840040000000000000000003E400000000000003440000000000000244000000000000034400000000000002E4000000000000024400000000000003440000000000000394000000000000010400000000000003E4000000000000034400000000000002440"
    )
  end

  test "Decode MultiPolygonZ from WKB" do
    geom =
      Geo.WKB.decode!(
        "01060000800200000001030000800100000004000000000000000000444000000000000044400000000000004440000000000000344000000000008046400000000000004E4000000000008046400000000000003E400000000000002E400000000000004440000000000000444000000000000044400103000080020000000600000000000000000034400000000000804140000000000000484000000000000024400000000000003E4000000000000049400000000000002440000000000000244000000000000024400000000000003E4000000000000014400000000000003240000000000080464000000000000034400000000000002440000000000000344000000000008041400000000000004840040000000000000000003E400000000000003440000000000000244000000000000034400000000000002E4000000000000024400000000000003440000000000000394000000000000010400000000000003E4000000000000034400000000000002440"
      )

    assert(
      geom.coordinates == [
        [[{40, 40, 40}, {20, 45, 60}, {45, 30, 15}, {40, 40, 40}]],
        [
          [{20, 35, 48}, {10, 30, 50}, {10, 10, 10}, {30, 5, 18}, {45, 20, 10}, {20, 35, 48}],
          [{30, 20, 10}, {20, 15, 10}, {20, 25, 4}, {30, 20, 10}]
        ]
      ]
    )
  end

  test "Decode MultiPolygonZ from EWKB" do
    geom =
      Geo.WKB.decode!(
        "01060000A0E61000000200000001030000800100000004000000000000000000444000000000000044400000000000004440000000000000344000000000008046400000000000004E4000000000008046400000000000003E400000000000002E400000000000004440000000000000444000000000000044400103000080020000000600000000000000000034400000000000804140000000000000484000000000000024400000000000003E4000000000000049400000000000002440000000000000244000000000000024400000000000003E4000000000000014400000000000003240000000000080464000000000000034400000000000002440000000000000344000000000008041400000000000004840040000000000000000003E400000000000003440000000000000244000000000000034400000000000002E4000000000000024400000000000003440000000000000394000000000000010400000000000003E4000000000000034400000000000002440"
      )

    assert(
      geom.coordinates == [
        [[{40, 40, 40}, {20, 45, 60}, {45, 30, 15}, {40, 40, 40}]],
        [
          [{20, 35, 48}, {10, 30, 50}, {10, 10, 10}, {30, 5, 18}, {45, 20, 10}, {20, 35, 48}],
          [{30, 20, 10}, {20, 15, 10}, {20, 25, 4}, {30, 20, 10}]
        ]
      ]
    )

    assert(geom.srid == 4326)
  end

  test "Encode Geometry Collection to and from WKB" do
    wkb =
      "010700000002000000010100000000000000000010400000000000001840010200000002000000000000000000104000000000000018400000000000001C400000000000002440"

    collection = Geo.WKB.decode!(wkb)
    assert(Enum.count(collection.geometries) == 2)
    assert(Geo.WKB.encode!(collection, :ndr) == wkb)
  end

  test "Encode Geometry Collection to and from EWKB" do
    ewkb =
      "0107000020E610000002000000010100000000000000000010400000000000001840010200000002000000000000000000104000000000000018400000000000001C400000000000002440"

    collection = Geo.WKB.decode!(ewkb)
    assert(Enum.count(collection.geometries) == 2)
    assert(hd(collection.geometries).srid == 4326)
    assert(List.last(collection.geometries).srid == 4326)
    assert(Geo.WKB.encode!(collection, :ndr) == ewkb)
  end

  test "MuliPolygon decoded correctly" do
    geom =
      Geo.WKB.decode!(
        "0106000020E6100000010000000103000000010000000F00000091A1EF7505D521C0F4AD6182E481424072B3CE92FED421C01D483CDAE281424085184FAEF7D421C0CB159111E1814240E1EBD7FBF8D421C0D421F7C8DF814240AD111315FFD421C0FE1F21C0DE81424082A0669908D521C050071118DE814240813C5E700FD521C0954EEF97DE814240DC889FA815D521C0B3382182E08142400148A81817D521C0E620D22BE2814240F1E95BDE19D521C08BD53852E3814240F81699E217D521C05B35D7DCE4814240B287C8D715D521C0336338FEE481424085882FB90FD521C0FEF65484E5814240A53E1E460AD521C09A0EA286E581424091A1EF7505D521C0F4AD6182E4814240"
      )

    assert(geom.srid == 4326)

    assert(
      geom.coordinates == [
        [
          [
            {-8.91605728674111, 37.014786050505705},
            {-8.916004741413165, 37.01473548835222},
            {-8.915952155261275, 37.014681049196575},
            {-8.915962095363229, 37.014641876859656},
            {-8.916008623674168, 37.01461030595236},
            {-8.916081231858929, 37.01459027129624},
            {-8.91613341474863, 37.01460551438246},
            {-8.91618086764759, 37.0146639501776},
            {-8.916191835920474, 37.01471469650441},
            {-8.91621298667903, 37.01474979186158},
            {-8.916197854221068, 37.01479683407043},
            {-8.916182273129241, 37.01480081322952},
            {-8.916135584881212, 37.01481680058167},
            {-8.916094008628827, 37.01481707489911},
            {-8.91605728674111, 37.014786050505705}
          ]
        ]
      ]
    )
  end

  test "Decoding of GeometryCollection with one geometry" do
    geom = %Geo.GeometryCollection{
      geometries: [%Geo.Point{coordinates: {54.1745659, 15.5398456}, srid: 4326}],
      srid: 4326
    }

    wkb = Geo.WKB.encode!(geom)
    geodata = Geo.WKB.decode!(wkb)

    assert wkb == "0020000007000010E6000000010000000001404B16582CE7BF97402F1466A479C76C"
    assert geom == geodata
  end

  test "Decoding of GeometryCollection with two geometries" do
    geom = %Geo.GeometryCollection{
      geometries: [
        %Geo.Point{coordinates: {54.1745659, 15.5398456}, srid: 4326},
        %Geo.Point{coordinates: {54.1745659, 15.5398456}, srid: 4326}
      ],
      srid: 4326
    }

    wkb = Geo.WKB.encode!(geom)
    geodata = Geo.WKB.decode!(wkb)

    assert geom == geodata
  end

  test "Decode WKB to Point using decode" do
    {:ok, point} = Geo.WKB.decode("0101000000000000000000F03F000000000000F03F")
    assert(point.coordinates == {1, 1})
  end

  test "Encode Point to WKB using encode" do
    geom = %Geo.Point{coordinates: {1, 1}}
    assert {:ok, "0101000000000000000000F03F000000000000F03F"} = Geo.WKB.encode(geom, :ndr)
  end

  property "encodes and decodes back to the correct Point struct" do
    check all(
            x <- float(),
            y <- float()
          ) do
      geom = %Geo.Point{coordinates: {x, y}}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  property "encodes and decodes back to the correct PointM struct" do
    check all(
            x <- float(),
            y <- float(),
            m <- float()
          ) do
      geom = %Geo.PointM{coordinates: {x, y, m}}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  property "encodes and decodes back to the correct PointZ struct" do
    check all(
            x <- float(),
            y <- float(),
            z <- float()
          ) do
      geom = %Geo.PointZ{coordinates: {x, y, z}}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  property "encodes and decodes back to the correct PointZM struct" do
    check all(
            x <- float(),
            y <- float(),
            z <- float(),
            m <- float()
          ) do
      geom = %Geo.PointZM{coordinates: {x, y, z, m}}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  property "encodes and decodes back to the correct LineString struct" do
    check all(list <- list_of({float(), float()}, min_length: 1)) do
      geom = %Geo.LineString{coordinates: list}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  property "encodes and decodes back to the correct LineStringZ struct" do
    check all(list <- list_of({float(), float(), float()}, min_length: 1)) do
      geom = %Geo.LineStringZ{coordinates: list}
      assert geom == Geo.WKB.encode!(geom) |> Geo.WKB.decode!()
    end
  end

  test "Decode WKB iodata to Line String" do
    point =
      Geo.WKB.decode_iodata!(
        Base.decode16!(
          "0102000000030000000000000000003E40000000000000244000000000000024400000000000003E4000000000000044400000000000004440"
        )
      )

    assert(point.coordinates == [{30, 10}, {10, 30}, {40, 40}])
  end

  test "Decode WKB iodata to LineStringZ" do
    point =
      Geo.WKB.decode_iodata!(
        Base.decode16!(
          "008000000200000003403E000000000000402400000000000040080000000000004024000000000000403E0000000000004056800000000000404400000000000040440000000000004044000000000000"
        )
      )

    IO.inspect(point)

    assert(point.coordinates == [{30, 10, 3}, {10, 30, 90}, {40, 40, 40}])
  end
end
