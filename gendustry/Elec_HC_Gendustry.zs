print("Started loading of GendustryTweaks");
val powerModule = <gendustry:PowerModule>;
val piston = <minecraft:piston>;
val stone = <minecraft:stone>;
val lumiumIngot = <ThermalFoundation:material:75>;
val enderiumIngot = <ThermalFoundation:material:76>;
val electrumIngot = <ThermalFoundation:material:71>;
val shinyIngot = <ThermalFoundation:material:69>;
val electrumGear = <ThermalFoundation:material:135>;
val tinkersAlloyGear = <ThermalFoundation:material:137>;
val diamondChipset = <BuildCraft|Silicon:redstoneChipset>.withTag({type: "Diamond"});
val redstoneChipset = <BuildCraft|Silicon:redstoneChipset>;
val bronze = <ore:ingotBronze>;
val iron = <ore:ingotIron>;
val tin = <ore:ingotTin>;
val copper = <ore:ingotCopper>;
val sturdyMachine = <Forestry:sturdyMachine>;
val industrialGrafter = <gendustry:IndustrialGrafter>;
val industrialScoop = <gendustry:IndustrialScoop>;
val upgradeFrame = <gendustry:UpgradeFrame>;
val alvearySieve = <Forestry:tile.alveary:7>;
val string = <Forestry:craftingMaterial>;
val upgradeFrameSieve = <gendustry:ApiaryUpgrade:15>;


recipes.remove(powerModule);
recipes.remove(sturdyMachine);
recipes.remove(industrialGrafter);  ##Just removed
recipes.remove(industrialScoop);  ##Just removed
recipes.remove(upgradeFrame);
recipes.remove(upgradeFrameSieve);

recipes.addShaped(powerModule, [[electrumGear, lumiumIngot, tinkersAlloyGear], [piston, diamondChipset, piston], [tinkersAlloyGear, lumiumIngot, electrumGear]]);
recipes.addShaped(sturdyMachine, [[bronze, bronze, bronze], [bronze, redstoneChipset, bronze], [bronze, bronze, bronze]]);
recipes.addShaped(upgradeFrame, [[shinyIngot, null, shinyIngot], [enderiumIngot, tinkersAlloyGear, enderiumIngot], [shinyIngot, null, shinyIngot]]);
recipes.addShaped(upgradeFrameSieve, [[string, alvearySieve, string], [alvearySieve, upgradeFrame, alvearySieve], [null, null, null]]);

print("GendustryTweaks Loaded");
