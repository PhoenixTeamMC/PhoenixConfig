//The Following script goes with "Phoenix Shards" located in the Quadrum section of Phoenix Configs

val phoenixShard = <ore:phoenixShard>;
phoenixShard.add(<Quadrum:phoenixShard>);

val phoenixShardBlock = <ore:phoenixShardBlock>;
phoenixShard.add(<Quadrum:phoenixShardBlock>);

print(<Quadrum:phoenixShard>.displayName); // prints the original name
<Quadrum:phoenixShard>.displayName = "Phoenix Shard";
print(<Quadrum:phoenixShardBlock>.displayName); // prints the original name
<Quadrum:phoenixShardBlock>.displayName = "Phoenix Shard Block";
print(<Quadrum:phoenixShardSeasoning>.displayName); // prints the original name
<Quadrum:phoenixShardSeasoning>.displayName = "Phoenix Seasoning";
print(<Quadrum:phoenixRawChicken>.displayName); // prints the original name
<Quadrum:phoenixRawChicken>.displayName = "Seasoned Chicken";
print(<Quadrum:phoenixChicken>.displayName); // prints the original name
<Quadrum:phoenixChicken>.displayName = "Phoenix Meat";

recipes.addShaped(<Quadrum:phoenixShardSeasoning>,
 [[<minecraft:potato>, <minecraft:glowstone_dust>, <minecraft:golden_carrot>],
  [<minecraft:glowstone_dust>, <Quadrum:phoenixShard>, <minecraft:glowstone_dust>],
  [<minecraft:golden_carrot>, <minecraft:glowstone_dust>, <minecraft:potato>]]);
  recipes.addShaped(<Quadrum:phoenixRawChicken> * 8,
 [[<minecraft:chicken>, <minecraft:chicken>, <minecraft:chicken>],
  [<minecraft:chicken>, <Quadrum:phoenixShardSeasoning>, <minecraft:chicken>],
  [<minecraft:chicken>, <minecraft:chicken>, <minecraft:chicken>]]);
recipes.addShaped(<Quadrum:phoenixShardBlock>, [[<Quadrum:phoenixShard>, <Quadrum:phoenixShard>], [<Quadrum:phoenixShard>, <Quadrum:phoenixShard>]]);
furnace.addRecipe(<Quadrum:phoenixChicken>, <Quadrum:phoenixRawChicken>);

vanilla.loot.addChestLoot("dungeonChest", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("mineshaftCorridor", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("pyramidDesertyChest", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("pyramidJungleChest", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("pyramidJungleDispencer", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("strongholdCorridor", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("strongholdLibrary", <Quadrum:phoenixShard>.weight(5), 1, 3);
vanilla.loot.addChestLoot("strongholdCrossing", <Quadrum:phoenixShard>.weight(5), 1, 3);
