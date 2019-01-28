<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" minScale="1e+08" version="3.4.1-Madeira" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <customproperties>
    <property value="Value" key="identify/format"/>
  </customproperties>
  <pipe>
    <rasterrenderer alphaBand="-1" band="1" type="singlebandpseudocolor" opacity="1" classificationMax="nan" classificationMin="nan">
      <minMaxOrigin>
        <limits>None</limits>
        <extent>WholeRaster</extent>
        <statAccuracy>Estimated</statAccuracy>
        <cumulativeCutLower>0.02</cumulativeCutLower>
        <cumulativeCutUpper>0.98</cumulativeCutUpper>
        <stdDevFactor>2</stdDevFactor>
      </minMaxOrigin>
      <rastershader>
        <colorrampshader classificationMode="1" clip="0" colorRampType="EXACT">
          <item label="0 - Unclassified" value="0" color="#000000" alpha="255"/>
          <item label="6 - merged_Water" value="6" color="#d765cd" alpha="255"/>
          <item label="8 - merged_Wetland" value="8" color="#6bf18d" alpha="255"/>
          <item label="14 - merged_Park" value="14" color="#c09e3b" alpha="255"/>
          <item label="20 - merged_Forest" value="20" color="#9f3293" alpha="255"/>
          <item label="27 - merged_Residential" value="27" color="#e7a790" alpha="255"/>
          <item label="32 - merged_Industrial" value="32" color="#5e59b1" alpha="255"/>
          <item label="39 - merged_Agriculture" value="39" color="#ba4701" alpha="255"/>
          <item label="40 - merged_Highrise" value="40" color="#c228c6" alpha="255"/>
        </colorrampshader>
      </rastershader>
    </rasterrenderer>
    <brightnesscontrast brightness="0" contrast="0"/>
    <huesaturation saturation="0" colorizeRed="255" colorizeBlue="128" grayscaleMode="0" colorizeStrength="100" colorizeOn="0" colorizeGreen="128"/>
    <rasterresampler maxOversampling="2"/>
  </pipe>
  <blendMode>0</blendMode>
</qgis>
