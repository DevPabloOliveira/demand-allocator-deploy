import geopandas as gpd
gdf = gpd.read_file('opportunities.geojson')
print(gdf.columns)
