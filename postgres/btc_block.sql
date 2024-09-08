CREATE TABLE IF NOT EXISTS public.btc_block
(
    hash bytea NOT NULL,
    confirmations integer,
    height integer NOT NULL,
    version integer NOT NULL,
    merkleroot bytea NOT NULL,
    "time" timestamp without time zone NOT NULL,
    mediantime timestamp without time zone NOT NULL,
    nonce bigint NOT NULL,
    difficulty numeric NOT NULL,
    chainwork bytea NOT NULL,
    ntx integer NOT NULL,
    previousblockhash bytea,
    nextblockhash bytea,
    strippedsize integer NOT NULL,
    size integer NOT NULL,
    weight integer NOT NULL,
    bits character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT btc_block_pkey PRIMARY KEY (hash)
)
