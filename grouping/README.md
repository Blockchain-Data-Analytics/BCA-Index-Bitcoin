# Groups of transaction outputs

## Definition

* the user searches using a group id instead of the private search term
* the group id is derived from the search criteria through hashing, and taking a fixed length prefix of the hash
* for all potential search fields in the database, there is a precalculated mapping to group ids
  * for example, when searching for a transaction the user will hash the search txid, take a fixed length prefix of that and declare this the group id.
  * then, the server returns a relation with grp_id -> {block_height, txid} which the user can filter for the exact txid and the block height it appears in.
  * in a further step, the user requests a dump of the block at block_height and extracts the transaction from it.


* search with blockhash: relation "grp_id -> {block_height, block_hash, grp_id}"
* search with txid: relation "grp_id -> {block_height, txid, grp_id}"
* search with txhash: relation "grp_id -> {block_height, txhash, grp_id}"
* search with output address: relation "grp_id -> {block_height, txid, n_idx, address, grp_id}"

## Group relations

### Block hashes

```sql
SELECT height, hash, left(md5(hash :: VARCHAR), 3) AS grp_id FROM read_parquet('btc_256800-block.parquet');
```

output:
```sh
┌────────┬────────────────────────────────────────────────────────────────────┬─────────┐
│ height │                                hash                                │ grp_id  │
│ int32  │                                blob                                │ varchar │
├────────┼────────────────────────────────────────────────────────────────────┼─────────┤
│ 256800 │ \x000000000000000a4d7e1976840b58fd4c7ef857d21ea355e8af3b84a61e56aa │ 062     │
│ 256801 │ \x0000000000000006f72fd6d7f2e75293d07a587fbfa6b45bb8c431dfc83ab800 │ 4f1     │
│ 256802 │ \x000000000000001700cbaff6995a47a2f5d9c741b348170d21c95217919e5b7a │ ca7     │
│ 256803 │ \x00000000000000050c984f8b22fc5dc71ec94c8a954baa72d088e060c532868b │ 337     │
│ 256804 │ \x0000000000000012463bdc772cb5b13c4755d8b7ed1805ab7c5e96e20e60d2d5 │ cd4     │
│ 256805 │ \x000000000000002a091135532afc93a0353e1a869fbc3afa06519da14bbe05f0 │ 99d     │
│ 256806 │ \x0000000000000013424ef19b41f886b886e49c8ed379a3939689576b2fa1ec26 │ 1ae     │
│ 256807 │ \x00000000000000153972644a8991d5d9bd76bbde2f8219a2e020885f045f032c │ 581     │
│ 256808 │ \x0000000000000009653b6829961f8dab9750deade9587860968deaa50b7baf12 │ 9c5     │
│ 256809 │ \x0000000000000018b35fab5c72680d1e40c0f9b89f0006d165c6a6b7589ffdea │ 4b5     │
│ 256810 │ \x00000000000000203212b020faf7d28151f1a1c2df7b13732ba23d7377746615 │ 77a     │
│ 256811 │ \x000000000000000f7391ade3d86c773252c59a3f3676b446d5e38f6c34bbd5ec │ 1e3     │
│ 256812 │ \x0000000000000009af05fa42d688dd975249a21a3fe66389ca3a2a4a79373fb2 │ 7d7     │
│ 256813 │ \x000000000000001f00c4c88e75e90593e3581bd9aa204b1c7c6fa1b86d6864df │ cf5     │
│ 256814 │ \x00000000000000195c8f4282e8f6f0224ac07c61b4c33f5ecddaef3c6e447343 │ 6aa     │
│ 256815 │ \x000000000000000d42c7852c90608ddc8c5416acd04656f2f43988236cb72d67 │ 7fd     │
│ 256816 │ \x000000000000000d76a558b00f596dd38aad126880cba964d18e55ae041aabc2 │ 60b     │
│ 256817 │ \x00000000000000211c65b80a0be4cbf07ec39733728f302e128127391eeff199 │ 3af     │
│ 256818 │ \x0000000000000007bed1f8466a98c8bc483369ba611c59443895348a1f7ef8ce │ 034     │
│ 256819 │ \x0000000000000009aea9abe8fd6520c2295a94746d2e01378921ad1fc36ed4a9 │ ded     │
│    ·   │                                 ·                                  │  ·      │
│    ·   │                                 ·                                  │  ·      │
│    ·   │                                 ·                                  │  ·      │
│ 256880 │ \x00000000000000064b1b4135ef053d1bb6d605e35aceea6c7f5a98906d54c64c │ 2c1     │
│ 256881 │ \x000000000000001c658330f57e0148a1682f684b543d4b74e35fd4aa8c6b8270 │ 990     │
│ 256882 │ \x0000000000000025706ac528c0910f6fd80638a7d9820c83c854ddfcbcd7b3b4 │ 7e7     │
│ 256883 │ \x00000000000000245a74dfe7f5325cd9d11ed106b920eee2f851cd473a6b50ee │ 4d4     │
│ 256884 │ \x0000000000000002203b837e9725f541e1081bd4bee97b7474554e973b2c4e3f │ 7fc     │
│ 256885 │ \x000000000000001b8957b9c9df65200cb9f9dc985983e283de5d3a92bb55a737 │ e72     │
│ 256886 │ \x000000000000000d5ea9cb62e1b12912423a3cc36ff2e375eb884621eed2079c │ 636     │
│ 256887 │ \x0000000000000021c74fcc4eede363249fed4bb8c992659768f73dbd35062d4c │ e1f     │
│ 256888 │ \x00000000000000089837d73545d0e6d06c759a84df3ec17484f00c75dd9b00c4 │ aba     │
│ 256889 │ \x0000000000000011c027c2ed60fd33e29cb3c9ff732aa10d3de74cb5ec97275b │ 995     │
│ 256890 │ \x000000000000002364221d1aa0b08341a053617977ed9bd72d0625f711265780 │ f64     │
│ 256891 │ \x0000000000000007803b9935e66411472ba633edc09341a41e3842207b80cbce │ c66     │
│ 256892 │ \x0000000000000017260e3e0cd5bcf880e9dc0ae5737334100bf0e3db1c06f1f9 │ ada     │
│ 256893 │ \x000000000000003047775b226716e370048da03df86b863ba699a10dad225e02 │ e3e     │
│ 256894 │ \x000000000000001af4ac437761f765b86ef8bcba5165c67d962d603d3fe50834 │ 98a     │
│ 256895 │ \x0000000000000009307ec8318dc075450f4393c27a3fada12f0f778a1ae3f636 │ 039     │
│ 256896 │ \x000000000000001d6304ea6cd3bf7b0acbbd17904a5fcaf54d3e6a7429966949 │ 3f6     │
│ 256897 │ \x0000000000000025b9c431b5486b5be831ab05df8fb6c80879befbbe5b2e1ce4 │ 863     │
│ 256898 │ \x00000000000000240f7f6b5a9053f7c8f98ba14cc71305d69695f532b5ab51af │ dba     │
│ 256899 │ \x000000000000000fdcd29fb4d86b3d22626b23cc4ccdc4274988e6fe59cc73e4 │ 731     │
├────────┴────────────────────────────────────────────────────────────────────┴─────────┤
│ 100 rows (40 shown)                                                         3 columns │
└───────────────────────────────────────────────────────────────────────────────────────┘
```

### Transaction identifiers

```sql
SELECT block.height, tx.txid, left(md5(tx.txid :: VARCHAR), 3) AS grp_id FROM read_parquet('btc_256800-tx.parquet') AS tx JOIN (SELECT height, hash FROM read_parquet('btc_256800-block.parquet')) AS block ON (block.hash = tx.blockhash);
```

output:

```sh
┌────────┬────────────────────────────────────────────────────────────────────┬─────────┐
│ height │                                txid                                │ grp_id  │
│ int32  │                                blob                                │ varchar │
├────────┼────────────────────────────────────────────────────────────────────┼─────────┤
│ 256800 │ \xA2156b9a7d8f6fe00b409404ab71613d4e55e3795b87bf30b88f1b5a2c689710 │ cd6     │
│ 256800 │ {502195ae98a0baebc06a19edec9606a02726dd0d98fd79e7a6a508c7b3230a    │ 1a5     │
│ 256800 │ I8fcff3c5a15d0cf6d314983bc37f2d82566160383f9d649e9e0523b8e9f11d    │ 54c     │
│ 256800 │ \xE81eec891695e46b63699a7a7ac3adf23342efbfc04f804c75c4d70777edecea │ 6f2     │
│ 256800 │ \x89e4634425fd856508a090373375319639e9715004855037d6929cc2283d94b4 │ 5a8     │
│ 256800 │ \xB407713b864d502f86457c4d8954753af9d6e2f493554a11a138de49bf373938 │ 6fa     │
│ 256800 │ \xEAfcd145d58e4a6c04fa93c3f08a76ec7309a11548460a9712bb7d676abc4bb4 │ aa2     │
│ 256800 │ f2ebd75990be98e4d33c4b61a2982ffd9fe37bc8a4e9d7f90371aeaa03cdec0    │ 1b0     │
│ 256800 │ T81e756056ad3702cd2708c3ea61850f31464e2aef7aa24953515d7ee3020db    │ 68c     │
│ 256800 │ 0886e508727f18f7d5fa8eb890035a41e8989bbf56883d9a3c23b834d484d8d    │ b47     │
│ 256800 │ \x802a5499c6a06b013ed24a7a405df23d122fe47492d363d4b6cf0ddbed574fce │ 7d5     │
│ 256800 │ \x1849b8e2bee9ea5156b8b08ac6e2a36b8b0295cd7eb5b181e1bca65d22f46438 │ 9bc     │
│ 256800 │ \xA96c9acef64d1a7896d9e2f64377168384f08a8be21232f088d7cff8de7c2093 │ a4d     │
│ 256800 │ \xCB65fd5b46834a3fd31afb9beee0880f8ed36d71bb2ccf25a55e97715000095c │ 0d4     │
│ 256800 │ #b477ca7baf5ab2d581188c9d466aacea327ff072580cb9283164a7fb936024    │ ec3     │
│ 256800 │ pfc8e9795d075e11929d7e36aa027d30195228d6fa35ab3b9c8bb75e693bd20    │ 8b3     │
│ 256800 │ s6ecb78187ea9551f1b9bcb7f52d5383f7c72986572aabb92a438d66fc216a7    │ 6d7     │
│ 256800 │ \x0Fdbe28e90a93e8f67ba6cd1e860635fd3d252e3adadca87abdaea48b281093f │ cc7     │
│ 256800 │ a9819432577cea7b14dd6ae388c2ba7015dc62c62d69d48f466e43c240403fa    │ 9be     │
│ 256800 │ C4a7f9f13052049356128eb7ab88ad1accc3d5d37ae1aa593e450aa5cd0f6c2    │ 938     │
│    ·   │                                ·                                   │  ·      │
│    ·   │                                ·                                   │  ·      │
│    ·   │                                ·                                   │  ·      │
│ 256859 │ \x8035021d5af3b7ace159b1bb359fa9cde8566b52a55ea36d5908190d952cace7 │ 8f1     │
│ 256859 │ xf149fbde85b1fe0cd61394af4c1119aad4d93f64682470d6ea28ef0d6dbe07    │ 181     │
│ 256859 │ id4ca21bb06ed52d17d07c52ef6351a493de721a72f0c315502caf5dcf16192    │ aaf     │
│ 256859 │ `746c44f43e5b116947e0663deca53762b075f0527491c391c3c9fdd73da8bc    │ d31     │
│ 256859 │ \xCF8debd8e54ea38f747ab673e53ffef8b1bf53c23816362c0aa3aea18db429b2 │ 95f     │
│ 256859 │ \xFB9163b22a0120feda8c23fdb7046819cccd1cba81650e06c9764399bc3b7452 │ 7c2     │
│ 256859 │ \xE63c51cd768a14c74af51f7d573a83b4b5100ba29891c8f326f3b161d4304765 │ 577     │
│ 256859 │ \xC6e94bff0002fb93941466600d71d9b6afe7773a9a703b1d929a047de97c0f37 │ 9f2     │
│ 256859 │ \xF4e3cfb296de4260744581f616f2e337bd436fc40be453d3b544a3d95dc3fb78 │ 545     │
│ 256859 │ -6b85d5a733e7642d95f667495c6950e615cd8dc5e6bcba54ae99fab750ca61    │ 6e2     │
│ 256859 │ ne989442c0c24108fb927be9bf6534e5408b4ab066f1a7f733278517b70cb1c    │ 505     │
│ 256859 │ \x106f9e9649dbee10eef4a130e19d79bf201e54e93a5d1a778f8b52421398f805 │ 061     │
│ 256859 │ \x1C321e8c877229d92c6c81f7c5410748ad104843e1a12c5cc1c24dd4132cc882 │ 298     │
│ 256859 │ \xF00d4311bdc014e4555e06f1effae3fc205feb16d65bc2a4d6c7f66b84b95879 │ 326     │
│ 256859 │ bb9033766aae1187af85098a85b15217eef8ad7735708d06473e0ac4e689f3a    │ 04d     │
│ 256859 │ 675e01c9bf1d6db09bc84bf5f874ee5dc0016b317abaa9298ed0ea43e845ce4    │ 7c3     │
│ 256859 │ \xD78348c8aff4951b6904d27048a0de6319803fe486ba87b193de308f1c33f1d6 │ 797     │
│ 256859 │ \x81e440989017d81f9cff1d80420c7223e2f9272a0b95b17e40f866685231f2c1 │ 09b     │
│ 256859 │ \xABf2145b801c0b0c2a10b12591ba84387439b1bf3b6cee25e1c47186bff4e635 │ 045     │
│ 256859 │ \x04bd62d56bdf377399508d83ea8e541ce6a347f6cc7d9980afc460171dbcc27a │ 69f     │
├────────┴────────────────────────────────────────────────────────────────────┴─────────┤
│ 24869 rows (40 shown)                                                       3 columns │
└───────────────────────────────────────────────────────────────────────────────────────┘
```

### Transaction hashes

```sql
SELECT block.height, tx.txhash, left(md5(tx.txhash :: VARCHAR), 3) AS grp_id FROM read_parquet('btc_256800-tx.parquet') AS tx JOIN (SELECT height, hash FROM read_parquet('btc_256800-block.parquet')) AS block ON (block.hash = tx.blockhash);
```

output:
```sh
┌────────┬────────────────────────────────────────────────────────────────────┬─────────┐
│ height │                               txhash                               │ grp_id  │
│ int32  │                                blob                                │ varchar │
├────────┼────────────────────────────────────────────────────────────────────┼─────────┤
│ 256800 │ \xA2156b9a7d8f6fe00b409404ab71613d4e55e3795b87bf30b88f1b5a2c689710 │ cd6     │
│ 256800 │ {502195ae98a0baebc06a19edec9606a02726dd0d98fd79e7a6a508c7b3230a    │ 1a5     │
│ 256800 │ I8fcff3c5a15d0cf6d314983bc37f2d82566160383f9d649e9e0523b8e9f11d    │ 54c     │
│ 256800 │ \xE81eec891695e46b63699a7a7ac3adf23342efbfc04f804c75c4d70777edecea │ 6f2     │
│ 256800 │ \x89e4634425fd856508a090373375319639e9715004855037d6929cc2283d94b4 │ 5a8     │
│ 256800 │ \xB407713b864d502f86457c4d8954753af9d6e2f493554a11a138de49bf373938 │ 6fa     │
│ 256800 │ \xEAfcd145d58e4a6c04fa93c3f08a76ec7309a11548460a9712bb7d676abc4bb4 │ aa2     │
│ 256800 │ f2ebd75990be98e4d33c4b61a2982ffd9fe37bc8a4e9d7f90371aeaa03cdec0    │ 1b0     │
│ 256800 │ T81e756056ad3702cd2708c3ea61850f31464e2aef7aa24953515d7ee3020db    │ 68c     │
│ 256800 │ 0886e508727f18f7d5fa8eb890035a41e8989bbf56883d9a3c23b834d484d8d    │ b47     │
│ 256800 │ \x802a5499c6a06b013ed24a7a405df23d122fe47492d363d4b6cf0ddbed574fce │ 7d5     │
│ 256800 │ \x1849b8e2bee9ea5156b8b08ac6e2a36b8b0295cd7eb5b181e1bca65d22f46438 │ 9bc     │
│ 256800 │ \xA96c9acef64d1a7896d9e2f64377168384f08a8be21232f088d7cff8de7c2093 │ a4d     │
│ 256800 │ \xCB65fd5b46834a3fd31afb9beee0880f8ed36d71bb2ccf25a55e97715000095c │ 0d4     │
│ 256800 │ #b477ca7baf5ab2d581188c9d466aacea327ff072580cb9283164a7fb936024    │ ec3     │
│ 256800 │ pfc8e9795d075e11929d7e36aa027d30195228d6fa35ab3b9c8bb75e693bd20    │ 8b3     │
│ 256800 │ s6ecb78187ea9551f1b9bcb7f52d5383f7c72986572aabb92a438d66fc216a7    │ 6d7     │
│ 256800 │ \x0Fdbe28e90a93e8f67ba6cd1e860635fd3d252e3adadca87abdaea48b281093f │ cc7     │
│ 256800 │ a9819432577cea7b14dd6ae388c2ba7015dc62c62d69d48f466e43c240403fa    │ 9be     │
│ 256800 │ C4a7f9f13052049356128eb7ab88ad1accc3d5d37ae1aa593e450aa5cd0f6c2    │ 938     │
│    ·   │                                ·                                   │  ·      │
│    ·   │                                ·                                   │  ·      │
│    ·   │                                ·                                   │  ·      │
│ 256859 │ \x8035021d5af3b7ace159b1bb359fa9cde8566b52a55ea36d5908190d952cace7 │ 8f1     │
│ 256859 │ xf149fbde85b1fe0cd61394af4c1119aad4d93f64682470d6ea28ef0d6dbe07    │ 181     │
│ 256859 │ id4ca21bb06ed52d17d07c52ef6351a493de721a72f0c315502caf5dcf16192    │ aaf     │
│ 256859 │ `746c44f43e5b116947e0663deca53762b075f0527491c391c3c9fdd73da8bc    │ d31     │
│ 256859 │ \xCF8debd8e54ea38f747ab673e53ffef8b1bf53c23816362c0aa3aea18db429b2 │ 95f     │
│ 256859 │ \xFB9163b22a0120feda8c23fdb7046819cccd1cba81650e06c9764399bc3b7452 │ 7c2     │
│ 256859 │ \xE63c51cd768a14c74af51f7d573a83b4b5100ba29891c8f326f3b161d4304765 │ 577     │
│ 256859 │ \xC6e94bff0002fb93941466600d71d9b6afe7773a9a703b1d929a047de97c0f37 │ 9f2     │
│ 256859 │ \xF4e3cfb296de4260744581f616f2e337bd436fc40be453d3b544a3d95dc3fb78 │ 545     │
│ 256859 │ -6b85d5a733e7642d95f667495c6950e615cd8dc5e6bcba54ae99fab750ca61    │ 6e2     │
│ 256859 │ ne989442c0c24108fb927be9bf6534e5408b4ab066f1a7f733278517b70cb1c    │ 505     │
│ 256859 │ \x106f9e9649dbee10eef4a130e19d79bf201e54e93a5d1a778f8b52421398f805 │ 061     │
│ 256859 │ \x1C321e8c877229d92c6c81f7c5410748ad104843e1a12c5cc1c24dd4132cc882 │ 298     │
│ 256859 │ \xF00d4311bdc014e4555e06f1effae3fc205feb16d65bc2a4d6c7f66b84b95879 │ 326     │
│ 256859 │ bb9033766aae1187af85098a85b15217eef8ad7735708d06473e0ac4e689f3a    │ 04d     │
│ 256859 │ 675e01c9bf1d6db09bc84bf5f874ee5dc0016b317abaa9298ed0ea43e845ce4    │ 7c3     │
│ 256859 │ \xD78348c8aff4951b6904d27048a0de6319803fe486ba87b193de308f1c33f1d6 │ 797     │
│ 256859 │ \x81e440989017d81f9cff1d80420c7223e2f9272a0b95b17e40f866685231f2c1 │ 09b     │
│ 256859 │ \xABf2145b801c0b0c2a10b12591ba84387439b1bf3b6cee25e1c47186bff4e635 │ 045     │
│ 256859 │ \x04bd62d56bdf377399508d83ea8e541ce6a347f6cc7d9980afc460171dbcc27a │ 69f     │
├────────┴────────────────────────────────────────────────────────────────────┴─────────┤
│ 24869 rows (40 shown)                                                       3 columns │
└───────────────────────────────────────────────────────────────────────────────────────┘
```

### Output addresses

```sql
SELECT block.height, tx.txid, list_transform(from_json(tx.vout, '["json"]'), x -> json_extract(json(x), '$.scriptPubKey.address')) AS outputs, list_transform(from_json(tx.vout, '["json"]'), x -> left(md5(json_extract(json(x), '$.scriptPubKey.address')),3)) AS grp_ids FROM read_parquet('btc_256800-tx.parquet') AS tx JOIN (SELECT height, hash FROM read_parquet('btc_256800-block.parquet')) AS block ON (block.hash = tx.blockhash);
```

output:

```sh
┌────────┬──────────────────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬──────────────────────┐
│ height │             txid             │                                                                        outputs                                                                        │       grp_ids        │
│ int32  │             blob             │                                                                        json[]                                                                         │      varchar[]       │
├────────┼──────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼──────────────────────┤
│ 256800 │ \xA2156b9a7d8f6fe00b409404…  │ ["1JVQw1siukrxGFTZykXFDtcf6SExJVuTVE"]                                                                                                                │ [c2a]                │
│ 256800 │ {502195ae98a0baebc06a19ede…  │ ["12YWfpfsHuKAmMtFoAYfehXk9GN1oitGGU", "1E9cvrDV4cGN7afPgQd5nfqXXQEQUtHKmG"]                                                                          │ [d17, 185]           │
│ 256800 │ I8fcff3c5a15d0cf6d314983bc…  │ ["1GShQhaTPjrTHWkDJG8dncjPkfWxv5cC5P", "1Bza3cBGRWbR1GSiFasf2jTeVuPTA1ALft"]                                                                          │ [973, 67d]           │
│ 256800 │ \xE81eec891695e46b63699a7a…  │ ["1AmgnqpN5V7SaKWXc9nApf3NvyKzGHVabr", "18FBZsb9YAsdwTfvoVPxaSRmm9UN7fgyjD"]                                                                          │ [e0a, 86f]           │
│ 256800 │ \x89e4634425fd856508a09037…  │ ["1DMxHdUVdbym2GSq1ehT5izPu9dCWnVFNF", "1DUvrP4u7NXDSuPW5y4cLe6QNCJuYUbH1Y"]                                                                          │ [3c1, 1dc]           │
│ 256800 │ \xB407713b864d502f86457c4d…  │ [NULL]                                                                                                                                                │ [NULL]               │
│ 256800 │ \xEAfcd145d58e4a6c04fa93c3…  │ ["1NnyBioYM2PchMT2JGq65uit3WxUJqnGYo", "18CddFixEu1c6vq7QhLTjt2goW5GQkcnpj"]                                                                          │ [9bc, c60]           │
│ 256800 │ f2ebd75990be98e4d33c4b61a2…  │ ["1DDSkvA5Kqf1dFQCxjf4zfmQ1znFZfCSTR", "174X1C5Smw1dnTVxKDhoFpJB6cMhx5ykhw"]                                                                          │ [a21, db7]           │
│ 256800 │ T81e756056ad3702cd2708c3ea…  │ ["1PQ8NNjLaoHmRB5APfP4eaSB4nJRk89AB7", "1LTurbUfVNEoFphVhqHsTiC6S2CQhYgfud"]                                                                          │ [c51, 504]           │
│ 256800 │ 0886e508727f18f7d5fa8eb890…  │ ["16778Cza3a3xrpdwaMT49NfuBZqxdGGDGu", "17sJNkRWaU9xBDJvKYpQ4J2jt7feutybAt"]                                                                          │ [9d0, 1a9]           │
│ 256800 │ \x802a5499c6a06b013ed24a7a…  │ ["1JLJVFcbF9fLHEqzJuQYNzsDgMecfGQSXn", "13in3jxHtmbLndb5NZWYGvNy4bj7V27BoW"]                                                                          │ [8bd, 845]           │
│ 256800 │ \x1849b8e2bee9ea5156b8b08a…  │ ["1MC1HBCsFghYyzEtVkAZgTZMQhcUfU86oG", "1CmtiJY9qd2tzzWEEwJLNYhdV9Gd8GjENW"]                                                                          │ [0e8, 603]           │
│ 256800 │ \xA96c9acef64d1a7896d9e2f6…  │ ["1KcxHNAPCLwH8ir9M2U5PupcEFkyTmbXJg", "1NEmrrP4qHTh3BRX6YDaiHKH3ZM2zcz39y"]                                                                          │ [98e, c38]           │
│ 256800 │ \xCB65fd5b46834a3fd31afb9b…  │ ["1KrFR5yrByLkakf2gk8Jgq1kjNLzAjGiUo"]                                                                                                                │ [eab]                │
│ 256800 │ #b477ca7baf5ab2d581188c9d4…  │ ["1ExMeLYh15aGxuafXzkcVXrfPkkwVQtBBH", "128xQuHAoZfbEayFadsjveqwhXKG9jWZiR"]                                                                          │ [005, ae6]           │
│ 256800 │ pfc8e9795d075e11929d7e36aa…  │ ["1AUUAYDtZYTh6QijwkJ5VFGtRnLQND3eF1", "1MvK6uoCyJfK4XqRnUHG8iNbtrfzk1BQ2w"]                                                                          │ [398, c05]           │
│ 256800 │ s6ecb78187ea9551f1b9bcb7f5…  │ ["1EEQzdASji6yBnWXg96XkFQaKzh28rwda9", "1Nhv5Dqm4yWHoNqGVYCXSVPDbro3VR3WQd"]                                                                          │ [1a7, ee9]           │
│ 256800 │ \x0Fdbe28e90a93e8f67ba6cd1…  │ ["1Pvi88AmU37pc19G5ptofVoAVtjgQewcPA", "1JFFZ2qwmYqC5V4Eqkuvm7HETRSqHGJpTr"]                                                                          │ [c4e, fdf]           │
│ 256800 │ a9819432577cea7b14dd6ae388…  │ ["12sm4SqB4bZrDydoggHkvJWv8rrksUnygj", "1xjp16RkQjJDeZrRKdyn9Liw8oEz2dy3g"]                                                                           │ [cce, 870]           │
│ 256800 │ C4a7f9f13052049356128eb7ab…  │ ["1N3DgH9UUiPNP65nTMjcWh6XABLWgcpxMX", "1B9DHhVF6dtJrUnv3VXjHwhU7tk4aiw88W"]                                                                          │ [e6a, 1d2]           │
│    ·   │              ·               │                                      ·                                                                                                                │     ·                │
│    ·   │              ·               │                                      ·                                                                                                                │     ·                │
│    ·   │              ·               │                                      ·                                                                                                                │     ·                │
│ 256859 │ \x8035021d5af3b7ace159b1bb…  │ ["16348iaDfrTzzz1LtoJ6dZBFyXZq878K7W", "1BibNzidWqEZvvzr9BDfLNvV4VRfB3W6sa"]                                                                          │ [3b7, 7f6]           │
│ 256859 │ xf149fbde85b1fe0cd61394af4…  │ ["1Bet24kC9BqJeCbc27hkahoAsSVHLaYfLr", "1HeqYrCAVJpd9hjBHCRMo1AgJ4cg8emzuB"]                                                                          │ [1b5, 8cf]           │
│ 256859 │ id4ca21bb06ed52d17d07c52ef…  │ ["1GX7B8QYrWyyFsWJvUgxh2Hk5W3F9aHzC", "1Mf1ZQwyb5MeXKTmzrfQzngoXpSVMdMAdj"]                                                                           │ [88b, fbd]           │
│ 256859 │ `746c44f43e5b116947e0663de…  │ ["1dice97ECuByXAvqXpaYzSaQuPVvrtmz6", "16RKgTCUE3Jh5UkcvHyHXVrvFXzh6U1XpE"]                                                                           │ [f3c, 7c8]           │
│ 256859 │ \xCF8debd8e54ea38f747ab673…  │ ["1Kd8VsaeFtBCaQc6k6iFyHPPxuvzZzzGsd", "16cH4Td5g2aK2yALywDD4DvffJN5uu7nHk"]                                                                          │ [36e, 5c3]           │
│ 256859 │ \xFB9163b22a0120feda8c23fd…  │ ["17sdroXbdsvNeHe5yVxH8JCgUXbS2gbbdJ", "1EnZkDQy8UNwbVBxaMLYZmXqQ1XK47mEye"]                                                                          │ [ddc, 9e2]           │
│ 256859 │ \xE63c51cd768a14c74af51f7d…  │ ["1EASRtkA4vaBFg37m6xmV3at8yAj6Drm59", "1KuNTJy4NbRkaUppLU59c5ZwLnQaEEWLCD"]                                                                          │ [709, 624]           │
│ 256859 │ \xC6e94bff0002fb9394146660…  │ ["12ZyTyamVXm21G8X5MBKUTLxe1Ma8AvfFy", "1N7tnu1EQbq4g6WvwabZq6EUxM29dCjuQj"]                                                                          │ [6f0, bca]           │
│ 256859 │ \xF4e3cfb296de4260744581f6…  │ ["1ABeetUG3YmUcXdv6yH6JKSJVxzYTfwMch", "12ZEvD2kHfsW2zn5az2Y8kbcsyk5smksAH"]                                                                          │ [0ad, 444]           │
│ 256859 │ -6b85d5a733e7642d95f667495…  │ ["1dice8EMZmqKvrGE4Qc9bUFf9PX3xaYDp", "15FLibr3oxGtuCJwnRjCpkbpXAnCPS1v2L"]                                                                           │ [cac, 442]           │
│ 256859 │ ne989442c0c24108fb927be9bf…  │ ["1J8K6Sb8GbEAfRy1ZiGb2yT9eaBJ13TYmh", "1BUZ34MB4qVjoTamKJbrSLTj9vAG2Kgtd"]                                                                           │ [786, ca5]           │
│ 256859 │ \x106f9e9649dbee10eef4a130…  │ ["1DpisXe6jy3xdEAC3U5HKsm21JR379fF64", "15vHrYx1Up1CXVMcrqBWQR9zi32BxZULF8"]                                                                          │ [70c, 65e]           │
│ 256859 │ \x1C321e8c877229d92c6c81f7…  │ ["1ML7htRUTp1r5FXKUpmPJCHGBZm8cdiyeN", "1CfsAiYaVfk12dnZpZALcRSP9jjWDk26FX"]                                                                          │ [8e8, 26d]           │
│ 256859 │ \xF00d4311bdc014e4555e06f1…  │ ["185AqGHGuY9VfxVL5aaJN4uxdBKcNntccL", "1B9VKGWLEnYMknUfLE7jtAD4aZjrCmfNGC"]                                                                          │ [d62, 2d9]           │
│ 256859 │ bb9033766aae1187af85098a85…  │ ["14raTncNieUNof9psTJf4jwxJSM6ZKgfbp", "169bNSCPu96g1d2ibhUZ7RRjK8xGwQNzX2"]                                                                          │ [70d, 31a]           │
│ 256859 │ 675e01c9bf1d6db09bc84bf5f8…  │ ["1diceh18tiAJXW973Ku1boRida8hAcmpX", "18Pz6q9UxyL2BxWNuPc35GkupmSrtu7ryD"]                                                                           │ [7e0, d12]           │
│ 256859 │ \xD78348c8aff4951b6904d270…  │ ["1K95DCf8bCdinBb8WJeBp5c9QXKFXX9PTh", "1CfsAiYaVfk12dnZpZALcRSP9jjWDk26FX"]                                                                          │ [91b, 26d]           │
│ 256859 │ \x81e440989017d81f9cff1d80…  │ ["1dice7EYzJag7SxkdKXLr8Jn14WUb3Cf1", "1dice6YgEVBf88erBFra9BHf6ZMoyvG88", "1dice6DPtUMBpWgv8i4pG8HMjXv9qDJWN", "1Pyw1Td1jsEZgMWiJmjnKbCjvfD3tYzTrw"] │ [67f, 4c1, dca, e1a] │
│ 256859 │ \xABf2145b801c0b0c2a10b125…  │ ["1KU2F1mBejott1t6o2Knn7V7zrC6zTtfVL", "1866CHju5paMvj4jy5YArvs4MhwN6hctyw"]                                                                          │ [f0a, 661]           │
│ 256859 │ \x04bd62d56bdf377399508d83…  │ ["1xqsxUzAUV8o11agTavifyB63RGGTWG34", "1dice7EYzJag7SxkdKXLr8Jn14WUb3Cf1"]                                                                            │ [053, 67f]           │
├────────┴──────────────────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────────────────┤
│ 24869 rows (40 shown)                                                                                                                                                                                      4 columns │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

```
