
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


## Process

> list chunks:

mc ls --json minio440/idx-btc/ | jq -r ' [ .key, .size, .lastModified ] | @csv' > /var/tmp/chunk_idx-btc.csv

> extract blockheight:

cat /var/tmp/chunk_idx-btc.csv| sort | sed -ne 's/.*btc_\([0-9]*\)_100-block.parquet.*/\1/p;' > /var/tmp/idx-btc.lst


## Compare checksums of copied files

### get file list
```sh
SED=$(which gsed 2>/dev/null || which sed)

MINIO_BASE=minio440/vidx-btc
mc ls ${MINIO_BASE}/ --no-color > file-list-minio440-vidx-btc.lst

$SED -ne 's/.* \(btc_2.*.parquet\)$/\1/p;' file-list-minio440-vidx-btc.lst > parquet.lst
```

### run comparison

remark: etags in minio's meta data are only valid for smaller files!


```sh```
MSF_BASE=${HOME}/MFS/vidx-btc

# mac
#MD5=md5
#MD5OPTS="-q"
MD5PROC=cat

# linux
MD5=md5sum
MD5OPTS="-b"
MD5PROC="$SED -ne 's/^\([0-9a-f]\+\) .*\$/\1/p;'"

for PARQUET_FP in $(cat parquet.lst); do 
  MINIO_MD5=''
  MINIO_MD5=$(mc get --disable-pager ${MINIO_BASE}/${PARQUET_FP} /tmp/${PARQUET_FP} > /dev/null && ${MD5} ${MD5OPTS} /tmp/${PARQUET_FP} | eval ${MD5PROC} && rm /tmp/${PARQUET_FP})
  if [ -n "${MINIO_MD5}" ]; then
    MFS_MD5=''
    MFS_MD5=$(${MD5} ${MD5OPTS} ${MSF_BASE}/${PARQUET_FP} | eval ${MD5PROC})
    if [ -n "${MFS_MD5}" -a "${MFS_MD5}" = "${MINIO_MD5}" ]; then
      echo ${PARQUET_FP} >> ok_md5.lst
      echo "OK ${PARQUET_FP}"
    else
      echo ${PARQUET_FP} >> failed_md5.lst
      echo "FAILED ${PARQUET_FP}"
    fi
  else
    echo "Cannot stat ${PARQUET_FP}"
  fi
  sleep 0
done


```

## Evaluate conscutive sequence of block heights are available

```sql
D .timer on
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_2[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│       100000 │
└──────────────┘
Run Time (s): real 0.620 user 0.288321 sys 0.183165
```

```sql
D .timer on
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_3[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│        99800 │
└──────────────┘
Run Time (s): real 6.970 user 3.091380 sys 2.261909
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_4[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│        89300 │
└──────────────┘
Run Time (s): real 8.263 user 4.322991 sys 3.604510
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_5[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│        91000 │
└──────────────┘
Run Time (s): real 8.437 user 4.979029 sys 3.812738
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_6[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│        96400 │
└──────────────┘
Run Time (s): real 8.762 user 5.052553 sys 3.888465
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_7[0-9][0-9][0-9]00_100-block.parquet') );
┌──────────────┐
│ count_star() │
│    int64     │
├──────────────┤
│        75400 │
└──────────────┘
Run Time (s): real 6.640 user 3.907732 sys 2.826131
D SELECT COUNT(*) FROM ( SELECT DISTINCT hash FROM read_parquet('/home/alex/MFS/vidx-btc/btc_8[0-9][0-9][0-9]00_100-block.parquet') );
Run Time (s): real 0.368 user 0.025090 sys 0.100748
IO Error: No files found that match the pattern "/home/alex/MFS/vidx-btc/btc_8[0-9][0-9][0-9]00_100-block.parquet"
```

### Find missing blocks

```sql
.mode csv

SELECT height, height - hdiff AS last_height, hdiff FROM (SELECT height, height - (lag(height) OVER (ORDER BY height ASC)) AS hdiff FROM read_parquet('/home/alex/MFS/vidx-btc/btc_3[0-9][0-9][0-9]00_100-block.parquet')) WHERE hdiff > 1;
┌────────┬─────────────┬───────┐
│ height │ last_height │ hdiff │
│ int32  │    int32    │ int32 │
├────────┼─────────────┼───────┤
│ 307900 │      307799 │   101 │
│ 357600 │      357499 │   101 │
└────────┴─────────────┴───────┘
```
-> redo missing 307800 and 357500



## Redo missing

1. in tekton: `for BH in 457500 458400 459400 470800; do export STARTBLOCKHEIGHT=$BH; envsubst <task-idx-btc-run.yaml | kubectl create -n ${NAMESPACE} -f -; done`
2. when done: `for BH in 457500 458400 459400 470800; do ./qa_chunk.sh $BH 100; done`
3. copy to MFS: `for BH in 457500 458400 459400 470800; do echo $BH; mc cp minio440/vidx-btc/btc_${BH}_100-block.parquet ~/MFS/vidx-btc/; mc cp minio440/vidx-btc/btc_${BH}_100-tx.parquet ~/MFS/vidx-btc/; done`

