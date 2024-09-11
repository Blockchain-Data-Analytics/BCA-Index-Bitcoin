
# Quality Assurance

scan parquet files in bucket "idx-btc"

if tests pass, then move parquet file to bucket "vidx-btc"

## Tests

- from the file names extract STARTBLOCKHEIGHT and NUMBLOCKS
- have both parquet files \_-tx.parquet and \_-block.parquet
- count of distinct blockhashes in block.parquet needs to be equal to NUMBLOCKS
- list of ordered block heights in block.parquet needs to be equal to [STARTBLOCKHEIGHT .. STARTBLOCKHEIGHT + NUMBLOCKS]
- count of distinct blockhashes in tx.parquet, joined to the corresponding block.parquet, needs to be equal to NUMBLOCKS
- count of transactions needs to be larger than NUMBLOCKS
- count of "coinbase" transactions needs to be equal to NUMBLOCKS

