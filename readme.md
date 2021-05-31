# flib's Cyberpunk 2077 Mods

## [IconicItems](/IconicItems/)

My first redscript mod, prevents (or warns) you about disassembling and selling items marked as **Iconic**

## [UI-Improvements](/UI-Improvements/)

My collection of quality-of-life UI improvements

------

## Stuff I want to look in to

### Mods

- [ ] Fixing HMG weapon mods
- [ ] @Pseudodiego#0822 on Discord asked if I could look into pushing custom messages to the journal
- [ ] Steal the AR driving directions from Panam's questline/street races and add them to regular driving nav
- [ ] Extract fonts used in-game and generate a list of supported glyphs
- [ ] Half the shit rfuzzo posted in [#modding-ideas-requests](https://discord.com/channels/717692382849663036/835141343684198430/847012820314226689)

### Redscript compiler additions:

- [ ] Add support for hex literals
- [ ] Add support for `enum == enum` conditional
- [ ] Add `struct` support (more complex than just a class flag)
- [ ] Add documentation comments to the AST
- [ ] Add attribute for appending to methods instead of replacing them
- [ ] Add support for casting `array<ref<*>>` to `array<Variant>` (if possible, might have to be `script_ref<*>`)
- [ ] Add support for C-style `for`-loops (as syntactic sugar since that's how CDPR's compiler does them)
- [ ] Add support for closures, or at least pseudo-anonymous inline functions (as syntatic sugar)

------

## Credits
- jekky for the [redscript compiler](https://github.com/jac3km4/redscript)
- djkovrik for releasing mods implementing the same features but faster than me
- The [CP77 modding discord](https://discord.gg/Epkq79kd96)
