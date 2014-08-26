//Recipe Tweaks and Addons
recipes.remove(<Botania:quartz>);
recipes.remove(<Botania:quartz:2>);
recipes.remove(<Botania:quartz:3>);
recipes.remove(<Botania:quartz:4>);
recipes.remove(<Botania:lexicon>);
recipes.remove(<Botania:prismarine>);
recipes.remove(<Botania:shinyFlower:*>);
recipes.remove(<Botania:runeAltar>);
recipes.remove(<Botania:altar>);
recipes.remove(<Botania:fireRod>);
recipes.remove(<Botania:skyDirtRod>);
recipes.remove(<Botania:terraformRod>);
recipes.remove(<Botania:waterRod>);
recipes.remove(<Botania:tornadoRod>);
recipes.remove(<Botania:rainbowRod>);
recipes.remove(<Botania:manaRing>);
recipes.remove(<Botania:manaRingGreater>);
recipes.remove(<Botania:auraRing>);
recipes.remove(<Botania:auraRingGreater>);
recipes.remove(<Botania:waterRing>);
recipes.remove(<Botania:magnetRing>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:9>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:10>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:11>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:12>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:13>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:14>);
mods.botania.RuneAltar.removeRecipe(<Botania:rune:15>);
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:quartz:3>, <minecraft:quartz>, "herba 1, victus 1, sensus 1");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:quartz>, <minecraft:quartz>, "ignis 1, potentia 1");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:quartz:2>, <minecraft:quartz>, "ignis, praecantatio 1");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:quartz:4>, <minecraft:quartz>, "potentia 1, machina 1");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:lexicon>, <minecraft:book>, "herba 4, arbor 2, praecantatio 1");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower>, <Botania:flower>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:1>, <Botania:flower:1>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:2>, <Botania:flower:2>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:3>, <Botania:flower:3>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:4>, <Botania:flower:4>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:5>, <Botania:flower:5>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:6>, <Botania:flower:6>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:7>, <Botania:flower:7>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:8>, <Botania:flower:8>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:9>, <Botania:flower:9>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:10>, <Botania:flower:10>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:11>, <Botania:flower:11>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:12>, <Botania:flower:12>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:13>, <Botania:flower:13>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:14>, <Botania:flower:14>, "lux 8");
mods.thaumcraft.Crucible.addRecipe("BASICSBTN", <Botania:shinyFlower:15>, <Botania:flower:15>, "lux 8");
mods.thaumcraft.Arcane.addShaped("RUNEALTAR", <Botania:runeAltar>, "ordo 20, aer 10, aqua 7, perditio 7",
[[<Botania:manaResource>, <Thaumcraft:blockStoneDevice:2>, <Botania:manaResource>],
[<Botania:livingrock>, <Thaumcraft:ItemShard:6>, <Botania:livingrock>],
[<Botania:livingrock>, <Botania:manaResource:2>, <Botania:livingrock>]]);
mods.thaumcraft.Arcane.addShaped("ALTAR", <Botania:altar>, "ordo 15, terra 12, aqua 9, perditio 10",
[[<minecraft:stone_slab:3>, <Botania:petal>, <minecraft:stone_slab:3>],
[null, <Thaumcraft:blockCosmeticSolid:6>, null],
[<minecraft:cobblestone>, <Thaumcraft:blockCosmeticOpaque>, <minecraft:cobblestone>]]);
mods.botania.Apothecary.addRecipe(<Thaumcraft:blockTaintFibres:2> * 3, [<Botania:manaPetal:10>, <Botania:manaPetal:15>, <Botania:petal:10>, <Botania:petal:15>, <Botania:rune:8>]);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:3>, <minecraft:wheat_seeds>, <Botania:manaResource:2>, <Botania:rune:5>, <minecraft:wheat_seeds>, <Botania:manaResource:2>], "victus 20, humanus 20", <Botania:rune:9>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:1>, <minecraft:cake>, <Botania:manaResource:2>, <Botania:rune:7>, <minecraft:cake>, <Botania:manaResource:2>], "fames 20", <Botania:rune:10>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:4>, <minecraft:gold_block>, <Botania:manaResource:2>, <Botania:rune>, <minecraft:gold_block>, <Botania:manaResource:2>], "lucrum 20", <Botania:rune:11>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:3>, <minecraft:potion:8266>, <Botania:manaResource:2>, <Botania:rune:6>, <minecraft:potion:8266>, <Botania:manaResource:2>], "motus 20", <Botania:rune:12>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:2>, <minecraft:golden_sword>, <Botania:manaResource:2>, <Botania:rune:7>, <minecraft:golden_sword>, <Botania:manaResource:2>], "telum 20", <Botania:rune:13>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:7>, <minecraft:ghast_tear>, <Botania:manaResource:2>, <Botania:rune>, <minecraft:ghast_tear>, <Botania:manaResource:2>], "humanus 20, cognitio 20", <Botania:rune:14>, 3);
mods.thaumcraft.Infusion.addRecipe("EVILRUNE", <Botania:livingrock>, [<Botania:rune:1>, <minecraft:ghast_tear>, <Botania:manaResource:2>, <Botania:rune:5>, <minecraft:ghast_tear>, <Botania:manaResource:2>], "humanus 20, cognitio 20", <Botania:rune:15>, 3);
mods.thaumcraft.Arcane.addShaped("PNR", <Botania:fireRod>, "ignis 20, perditio 10",
[[null, null, <Botania:quartz:2>],
[null, <Botania:manaResource:3>, null],
[<Botania:rune:1>, null, null]]);
mods.thaumcraft.Arcane.addShaped("PNR", <Botania:dirtRod>, "ordo 5, terra 20, perditio 10",
[[null, null, <minecraft:dirt>],
[null, <Botania:manaResource:3>, null],
[<Botania:rune:2>, null, null]]);
mods.thaumcraft.Arcane.addShapeless("PNR", <Botania:skyDirtRod>, "aer 30", [<Botania:dirtRod>, <Botania:rune:3>, <Botania:manaResource:8>]);
mods.thaumcraft.Infusion.addRecipe("PNR", <Botania:dirtRod>, [<Botania:rune:4>, <Botania:rune:5>, <Botania:grassSeeds>, <Botania:rune:6>, <Botania:rune:7>, <Botania:manaResource:4>], "terra 64", <Botania:terraformRod>, 5);
mods.thaumcraft.Arcane.addShaped("PNR", <Botania:waterRod>, "aqua 25",
[[null, null, <minecraft:potion>],
[null, <Botania:manaResource:3>, null],
[<Botania:rune>, null, null]]);
mods.thaumcraft.Arcane.addShaped("PNR", <Botania:tornadoRod>, "aer 40",
[[null, null, <minecraft:feather>],
[null, <Botania:manaResource:3>, null],
[<Botania:rune:3>, null, null]]);
mods.thaumcraft.Arcane.addShaped("PNR", <Botania:rainbowRod>, "ignis 50, terra 50, aqua 50, perditio 50, aer 50, ordo 50",
[[null, <Botania:manaResource:8>, <Botania:manaResource:9>],
[null, <Botania:manaResource:7>, <Botania:manaResource:8>],
[<Botania:manaResource:7>, null, null]]);
mods.thaumcraft.Infusion.addRecipe("PNR", <Botania:manaResource:2>, [<Botania:manaResource>, <minecraft:gold_ingot>, <Botania:manaResource>, <minecraft:gold_ingot>], "sensus 20, praecantatio 20", <Botania:pylon>, 5);
mods.thaumcraft.Infusion.addRecipe("PNR", <Botania:pylon>, [<Botania:manaResource:7>, <Botania:manaResource:8>, <Botania:manaResource:7>, <Botania:manaResource:8>], "iter 20, auram 10, praecantatio 20", <Botania:pylon:2>, 5);
mods.thaumcraft.Arcane.addShapeless("PNR", <Botania:pylon:1> * 2, "terra 80", [<Botania:pylon>, <Botania:pylon>, <Botania:manaResource:4>]);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource>, <Botania:manaResource>, <Botania:manaTablet:1000>, <Botania:manaResource>, <Botania:manaResource>], "lucrum 15, metallum 15, praecantatio 20, vacuos 20", <Botania:manaRing:1000>, 6);
mods.thaumcraft.Arcane.addShapeless("BTNB", <Botania:manaRingGreater:1000>, "terra 50, aqua 20", [<Botania:manaResource:4>, <Botania:manaRing>, <Botania:manaResource:4>]);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource>, <Botania:manaResource>, <Botania:rune:8>, <Botania:manaResource>, <Botania:manaResource>], "lucrum 15, metallum 15, praecantatio 20, sensus 20", <Botania:auraRing>, 6);
mods.thaumcraft.Arcane.addShapeless("BTNB", <Botania:auraRingGreater>, "terra 50, aer 20", [<Botania:manaResource:4>, <Botania:auraRing>, <Botania:manaResource:4>]);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource>, <minecraft:fish:2>, <Botania:manaResource>, <Botania:rune>, <Botania:manaResource>, <minecraft:fish:2>, <Botania:manaResource>], "aqua 30, motus 20", <Botania:waterRing>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource>, <Botania:manaResource>, <Botania:lens:10>, <Botania:manaResource>, <Botania:manaResource>], "aqua 30, ignis 30", <Botania:magnetRing>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource:7>, <Botania:manaResource:7>, <Botania:rune:15>, <Botania:manaResource:7>, <Botania:manaResource:7>], "fabrico 30, perfodio 30, telum 30", <Botania:reachRing>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource>, <Botania:manaResource>, <Botania:rune:2>, <Botania:manaResource>, <Botania:manaResource>, <minecraft:golden_pickaxe>], "perfodio 30, motus 30", <Botania:miningRing>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:1>, [<Botania:manaResource:7>, <Botania:manaResource:7>, <Botania:manaResource:8>, <Botania:manaResource:7>, <Botania:manaResource:7>], "auram 20, praecantatio 30", <Botania:pixieRing>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:2>, [<Botania:manaResource>, <Botania:rune:2>, <Botania:rune:3>], "motus 40", <Botania:travelBelt>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks:2>, [<Botania:manaResource>, <Botania:rune:2>, <Botania:rune:1>], "telum 20 motus 20", <Botania:knockbackBelt>, 6);
mods.thaumcraft.Arcane.addShaped("BTNB", <Botania:superTravelBelt>, "aer 70, perditio 30",
[[<Botania:manaResource:7>, <Botania:travelBelt>, <Botania:manaResource:7>],
[null, <Botania:manaResource:5>, null],
[null, null, null]]);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks>, [<Botania:manaResource>, <Botania:rune>, <Botania:rune:7>], "gelum 40, aqua 30", <Botania:icePendant>, 6);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Thaumcraft:ItemBaubleBlanks>, [<Botania:manaResource>, <Botania:rune:1>, <Botania:rune:5>], "ignis 40, tutamen 20", <Botania:lavaPendant>, 6);
mods.thaumcraft.Arcane.addShaped("BTNB", <Botania:superLavaPendant>, "ignis 60",
[[<minecraft:blaze_rod>, <Botania:quartz:2>, <minecraft:blaze_rod>],
[<Botania:quartz:2>, <Botania:lavaPendant>, <Botania:quartz:2>],
[<Botania:customBrick>, <Botania:manaResource:5>, <Botania:customBrick>]]);
mods.thaumcraft.Infusion.addRecipe("BTNB", <Botania:manaResource:1>, [<Botania:livingrock>, <minecraft:stone>, <Botania:livingrock>, <minecraft:stone>, <Botania:livingrock>, <minecraft:stone>, <Botania:livingrock>, <minecraft:stone>], "ignis 20, aer 20, terra 20, aqua 20, ordo 20, perditio 20, praecantation 50", <Botania:tinyPlanet>, 6);
mods.thaumcraft.Arcane.addShaped("BTNB", <Botania:flightTiara>, "aer 80",
[[<Botania:manaResource:5>, <Botania:manaResource:5>, <Botania:manaResource:5>],
[<Botania:manaResource:7>, <Botania:manaResource:5>, <Botania:manaResource:7>],
[<minecraft:feather>, <Botania:manaResource:7>, <minecraft:feather>]]);

//The Tab
mods.thaumcraft.Research.addTab("BTN", "botania", "textures/items/dragonstone.png");
mods.modtweaker.setLocalization("en_US", "tc.research_category.BTN", "Botania");

//Botania-TC 101
mods.thaumcraft.Research.addResearch("BASICSBTN", "BTN", "herba 100, terra 150, sensus 200", 0, 0, 4, <Botania:lexicon>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.BASICSBTN", "Botania-TC 101");
mods.modtweaker.setLocalization("en_US", "tc.research_text.BASICSBTN", "[BTN]Changes you need to know.");
mods.thaumcraft.Research.addPage("BASICSBTN", "derp.research_page.BASICSBTN");
mods.modtweaker.setLocalization("en_US", "derp.research_page.BASICSBTN", "Hello and welcome to the Botania-Thaumcraft addon config by SkeletonPunk!<BR>This was developed to bridge the mods Thaumcraft 4 and Botania so they would work together<BR>This little area is just for showing the basics you will need to know before you can start.<BR>Now, Lets start our little cross mod endeavour by crafting a Lexicon.");
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:lexicon>);
mods.thaumcraft.Research.addPage("BASICSBTN", "One group of materials you might find yourself using are the quartz from Botania.");
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:quartz>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:quartz:2>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:quartz:3>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:quartz:4>);
mods.thaumcraft.Research.addPage("BASICSBTN", "Shiny Flowers can be used to craft objects that stablize infusion.");
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:1>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:2>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:3>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:4>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:5>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:6>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:7>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:8>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:9>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:10>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:11>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:12>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:13>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:14>);
mods.thaumcraft.Research.addCruciblePage("BASICSBTN", <Botania:shinyFlower:15>);

//Runic Altar
mods.thaumcraft.Research.addResearch("RUNEALTAR", "BTN", "praecantatio 200, herba 100, metallum 150, sensus 200", 2, 0, 5, <Botania:runeAltar>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.RUNEALTAR", "Runic Altar");
mods.modtweaker.setLocalization("en_US", "tc.research_text.RUNEALTAR", "[BTN]Botania essentials");
mods.thaumcraft.Research.addPage("RUNEALTAR", "derp.research_page.RUNEALTAR");
mods.modtweaker.setLocalization("en_US", "derp.research_page.RUNEALTAR", "The Runic Altars main use is to infuse items into living rock in order to make PURE runes");
mods.thaumcraft.Research.addArcanePage("RUNEALTAR", <Botania:runeAltar>);
mods.thaumcraft.Research.addPrereq("RUNEALTAR", "BASICSBTN", false);

//Altar
mods.thaumcraft.Research.addResearch("ALTAR", "BTN", "praecantatio 200, herba 200, terra 150, sensus 150, perditio 100", -2, 0, 5, <Botania:altar>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.ALTAR", "Petal Apothecary");
mods.modtweaker.setLocalization("en_US", "tc.research_text.ALTAR", "[BTN]Botania essentials");
mods.thaumcraft.Research.addPage("ALTAR", "derp.research_page.ALTAR");
mods.modtweaker.setLocalization("en_US", "derp.research_page.ALTAR", "The Petal Apothecary is used to make magic based plants");
mods.thaumcraft.Research.addArcanePage("ALTAR", <Botania:altar>);
mods.thaumcraft.Research.addPrereq("ALTAR", "BASICSBTN", false);

//Taint Recipe
mods.thaumcraft.Research.addResearch("TAINTR", "BTN", "praecantatio 200, vitium 200, sensus 150, herba 150, fabrico 100", -4, 0, 6, <Thaumcraft:blockTaintFibres:2>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.TAINTR", "New Petal Apothecary Recipes");
mods.modtweaker.setLocalization("en_US", "tc.research_text.TAINTR", "Be happy!");
mods.thaumcraft.Research.addPage("TAINTR", "derp.research_page.TAINTR");
mods.modtweaker.setLocalization("en_US", "derp.research_page.TAINTR", "Tired of those pesky taint tendrils evaporating and infecting you but need it for still need it for something? Well look no further because this recipe does everything and more!<BR>WARNING:does not do more.");
mods.thaumcraft.Research.addPage("TAINTR", "Taint Plant:<BR>1 Mystical Purple Petal<BR>1 Mystical Black Petal<BR>1 Purple Mana Petal<BR>1 Black Mana Petal<BR>1 Rune of Mana");
mods.thaumcraft.Research.addPrereq("TAINTR", "ALTAR", false);

//Corrupted Runes
mods.thaumcraft.Research.addResearch("EVILRUNES", "BTN", "praecantatio 200, sensus 200, terra 150, perditio 150, lucrum 100", 4, -1, 8, <Botania:rune:9>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.EVILRUNES", "Corrupting Runes");
mods.modtweaker.setLocalization("en_US", "tc.research_text.EVILRUNES", "Spooky Scary Skeletons!");
mods.thaumcraft.Research.addPage("EVILRUNES", "derp.research_page.EVILRUNES");
mods.modtweaker.setLocalization("en_US", "derp.research_page.EVILRUNES", "Corrupted Runes are like runes, but... corrupted... kind of implied I know");
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:9>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:10>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:11>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:12>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:13>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:14>);
mods.thaumcraft.Research.addInfusionPage("EVILRUNES", <Botania:rune:15>);
mods.thaumcraft.Research.addPrereq("EVILRUNES", "RUNEALTAR", false);

//Pylons and Rods
mods.thaumcraft.Research.addResearch("PNR", "BTN", "praecantatio 200, sensus 200, terra 150, perditio 150, lucrum 100, iter 250, alienis 250", 4, 0, 8, <Botania:fireRod>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.PNR", "Pylons and Rods");
mods.modtweaker.setLocalization("en_US", "tc.research_text.PNR", "Useful Utilities and Magical Floaties!");
mods.thaumcraft.Research.addPage("PNR", "derp.research_page.PNR");
mods.modtweaker.setLocalization("en_US", "derp.research_page.PNR", "Thaumcraft may have their staves and wands, but Botania has bad ass forces of nature infused into a stick!<BR>#BotaniaMasterRace");
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:fireRod>);
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:dirtRod>);
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:skyDirtRod>);
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:waterRod>);
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:rainbowRod>);
mods.thaumcraft.Research.addInfusionPage("PNR", <Botania:terraformRod>);
mods.thaumcraft.Research.addInfusionPage("PNR", <Botania:pylon>);
mods.thaumcraft.Research.addInfusionPage("PNR", <Botania:pylon:2>);
mods.thaumcraft.Research.addArcanePage("PNR", <Botania:pylon:1>);
mods.thaumcraft.Research.addPrereq("PNR", "RUNEALTAR", false);

//Baubles
mods.thaumcraft.Research.addResearch("BTNB", "BTN", "praecantatio 200, sensus 200, terra 150, perditio 150, lucrum 100", 4, 1, 8, <Botania:manaRingGreater>);
mods.modtweaker.setLocalization("en_US", "tc.research_name.BTNB", "Baubles");
mods.modtweaker.setLocalization("en_US", "tc.research_text.BTNB", "Trinkets and Doo-dads");
mods.thaumcraft.Research.addPage("BTNB", "derp.research_page.BTNB");
mods.modtweaker.setLocalization("en_US", "derp.research_page.BTNB", "Trinkets for your everyday life");
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:manaRing:1000>);
mods.thaumcraft.Research.addArcanePage("BTNB", <Botania:manaRingGreater:1000>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:auraRing>);
mods.thaumcraft.Research.addArcanePage("BTNB", <Botania:auraRingGreater>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:waterRing>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:magnetRing>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:reachRing>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:miningRing>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:pixieRing>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:travelBelt>);
mods.thaumcraft.Research.addArcanePage("BTNB", <Botania:superTravelBelt>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:knockbackBelt>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:icePendant>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:lavaPendant>);
mods.thaumcraft.Research.addArcanePage("BTNB", <Botania:superLavaPendant>);
mods.thaumcraft.Research.addInfusionPage("BTNB", <Botania:tinyPlanet>);
mods.thaumcraft.Research.addArcanePage("BTNB", <Botania:flightTiara>);
mods.thaumcraft.Research.addPrereq("BTNB", "RUNEALTAR", false);
